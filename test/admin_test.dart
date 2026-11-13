import 'dart:convert';

import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

void main() {
  const profile = Driver(
    id: '019a1b2c-0000-7000-8000-000000000001',
    name: 'João da Silva',
    nickname: 'Joãozinho',
    city: 'Ribeirão Preto',
  );
  const admin = AdminDriver(profile: profile, phone: '16999990000', email: 'joao@example.com');

  group('AdminDriver', () {
    test('ida e volta no JSON', () {
      final json = jsonDecode(jsonEncode(admin.toJson())) as Map<String, Object?>;

      expect(AdminDriver.fromJson(json), admin);
    });

    test('o JSON é o do piloto público mais telefone e e-mail, no mesmo nível', () {
      final json = admin.toJson();

      expect(
        json.keys,
        unorderedEquals([
          ...profile.toJson().keys,
          AdminDriverJsonKeys.phone,
          AdminDriverJsonKeys.email,
        ]),
      );
      expect(json[AdminDriverJsonKeys.phone], '16999990000');
      expect(json[DriverJsonKeys.name], profile.name);
    });

    test('telefone é obrigatório e e-mail é opcional', () {
      final withoutEmail = admin.toJson()..remove(AdminDriverJsonKeys.email);

      expect(
        AdminDriver.fromJson(withoutEmail),
        const AdminDriver(profile: profile, phone: '16999990000'),
      );
      expect(() => AdminDriver.fromJson(profile.toJson()), throwsFormatException);
    });

    test('contato de tipo errado lança FormatException', () {
      final json = admin.toJson()..[AdminDriverJsonKeys.phone] = 16999990000;

      expect(() => AdminDriver.fromJson(json), throwsFormatException);
    });

    test('Duo lido com o piloto do painel descarta o contato', () {
      final json = {
        DuoJsonKeys.id: 'duo',
        DuoJsonKeys.driver: admin.toJson(),
        DuoJsonKeys.car: const Car(id: 'c', name: 'Opalão').toJson(),
      };

      final driverJson = Duo.fromJson(json).toJson()[DuoJsonKeys.driver]! as Map<String, Object?>;

      expect(driverJson, isNot(contains(AdminDriverJsonKeys.phone)));
      expect(driverJson, isNot(contains(AdminDriverJsonKeys.email)));
    });

    test('profile tem só os dados públicos', () {
      expect(AdminDriver.fromJson(admin.toJson()).profile, profile);
    });
  });

  group('AdminDuo', () {
    const car = Car(id: '019a1b2c-0000-7000-8000-000000000002', name: 'Opalão');
    const duo = AdminDuo(
      id: '019a1b2c-0000-7000-8000-000000000003',
      driver: admin,
      car: car,
      showsHistory: true,
      position: 3,
    );

    test('ida e volta no JSON, com o contato do piloto', () {
      final json = jsonDecode(jsonEncode(duo.toJson())) as Map<String, Object?>;

      expect(AdminDuo.fromJson(json), duo);
      expect(
        (json[DuoJsonKeys.driver]! as Map<String, Object?>)[AdminDriverJsonKeys.phone],
        '16999990000',
      );
    });

    test('fora da lista, a posição vai como null', () {
      const outside = AdminDuo(id: 'd', driver: admin, car: car);
      final json = jsonDecode(jsonEncode(outside.toJson())) as Map<String, Object?>;

      expect(json[AdminDuoJsonKeys.position], isNull);
      expect(AdminDuo.fromJson(json), outside);
    });

    test('public é a mesma dupla sem o contato', () {
      expect(
        duo.public,
        const Duo(
          id: '019a1b2c-0000-7000-8000-000000000003',
          driver: profile,
          car: car,
          showsHistory: true,
        ),
      );
    });

    test('posição que não é número ou marca ausente lançam FormatException', () {
      final textPosition = duo.toJson()..[AdminDuoJsonKeys.position] = '3';
      final withoutMark = duo.toJson()..remove(DuoJsonKeys.showsHistory);

      expect(() => AdminDuo.fromJson(textPosition), throwsFormatException);
      expect(() => AdminDuo.fromJson(withoutMark), throwsFormatException);
    });
  });

  group('AdminPublication', () {
    final failed = AdminPublication(
      queue: PublicationQueue.requested,
      hasUnpublishedChanges: true,
      lastPublishedAt: DateTime.utc(2026, 11, 12, 7),
      lastAttempt: PublicationAttempt(
        finishedAt: DateTime.utc(2026, 11, 13, 7, 3),
        result: PublicationResult.failed,
        message: 'build falhou',
      ),
    );

    test('ida e volta no JSON', () {
      final json = jsonDecode(jsonEncode(failed.toJson())) as Map<String, Object?>;

      expect(AdminPublication.fromJson(json), failed);
    });

    test('os instantes saem em UTC e voltam em UTC, mesmo com outro fuso', () {
      final json = failed.toJson();

      expect(json[AdminPublicationJsonKeys.lastPublishedAt], '2026-11-12T07:00:00.000Z');

      json[AdminPublicationJsonKeys.lastPublishedAt] = '2026-11-12T04:00:00-03:00';
      final read = AdminPublication.fromJson(json).lastPublishedAt!;

      expect(read.isUtc, isTrue);
      expect(read, DateTime.utc(2026, 11, 12, 7));
    });

    test('nunca publicado: sem data e sem tentativa', () {
      const empty = AdminPublication(queue: PublicationQueue.idle, hasUnpublishedChanges: true);
      final json = empty.toJson();

      expect(json[AdminPublicationJsonKeys.lastPublishedAt], isNull);
      expect(json[AdminPublicationJsonKeys.lastAttempt], isNull);
      expect(AdminPublication.fromJson(json), empty);
    });

    test('valores JSON dos enums', () {
      expect(PublicationQueue.values.map((item) => item.jsonValue), [
        'idle',
        'requested',
        'running',
      ]);
      expect(PublicationResult.values.map((item) => item.jsonValue), ['published', 'failed']);
    });

    test('instante sem fuso, fila desconhecida ou booleano errado lançam FormatException', () {
      Map<String, Object?> json() => failed.toJson();

      expect(
        () => AdminPublication.fromJson(
          json()..[AdminPublicationJsonKeys.lastPublishedAt] = '2026-11-12T07:00:00',
        ),
        throwsFormatException,
      );
      expect(
        () => AdminPublication.fromJson(json()..[AdminPublicationJsonKeys.queue] = 'paused'),
        throwsFormatException,
      );
      expect(
        () => AdminPublication.fromJson(
          json()..[AdminPublicationJsonKeys.hasUnpublishedChanges] = 'sim',
        ),
        throwsFormatException,
      );
    });
  });
}
