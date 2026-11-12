import 'dart:convert';

import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

/// Passa o JSON por texto, como chega pela rede.
Map<String, Object?> overTheWire(Map<String, Object?> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, Object?>;

void main() {
  const driver = Driver(
    id: '019a1b2c-0000-7000-8000-000000000001',
    name: 'João da Silva',
    nickname: 'Joãozinho',
    city: 'Ribeirão Preto',
    photoUrl: 'https://cdn.example/drivers/1.jpg',
    logoUrl: 'https://cdn.example/drivers/1-logo.png',
  );
  const car = Car(
    id: '019a1b2c-0000-7000-8000-000000000002',
    name: 'Opalão',
    photoUrls: ['https://cdn.example/cars/2-a.jpg', 'https://cdn.example/cars/2-b.jpg'],
  );

  group('Driver', () {
    test('ida e volta no JSON', () {
      expect(Driver.fromJson(overTheWire(driver.toJson())), driver);
    });

    test('sem foto e sem logo vai e volta como null', () {
      const bare = Driver(id: 'd', name: 'Ana', nickname: 'Aninha', city: 'Franca');
      final json = overTheWire(bare.toJson());

      expect(json[DriverJsonKeys.photoUrl], isNull);
      expect(json[DriverJsonKeys.logoUrl], isNull);
      expect(Driver.fromJson(json), bare);
    });

    test('aceita foto e logo ausentes no JSON', () {
      final json = {
        DriverJsonKeys.id: 'd',
        DriverJsonKeys.name: 'Ana',
        DriverJsonKeys.nickname: 'Aninha',
        DriverJsonKeys.city: 'Franca',
      };

      expect(Driver.fromJson(json).photoUrl, isNull);
    });

    test('o modelo público não tem telefone nem e-mail', () {
      expect(
        driver.toJson().keys,
        unorderedEquals(<String>[
          DriverJsonKeys.id,
          DriverJsonKeys.name,
          DriverJsonKeys.nickname,
          DriverJsonKeys.city,
          DriverJsonKeys.photoUrl,
          DriverJsonKeys.logoUrl,
        ]),
      );
      expect(driver.toJson(), isNot(contains(AdminDriverJsonKeys.phone)));
      expect(driver.toJson(), isNot(contains(AdminDriverJsonKeys.email)));
    });

    test('lido do JSON do painel, descarta o contato', () {
      final adminJson = const AdminDriver(
        profile: driver,
        phone: '16999990000',
        email: 'joao@example.com',
      ).toJson();

      final json = Driver.fromJson(adminJson).toJson();

      expect(json, isNot(contains(AdminDriverJsonKeys.phone)));
      expect(json, isNot(contains(AdminDriverJsonKeys.email)));
    });

    test('campo obrigatório ausente lança FormatException', () {
      final json = driver.toJson()..remove(DriverJsonKeys.nickname);

      expect(() => Driver.fromJson(json), throwsFormatException);
    });

    test('tipo errado lança FormatException', () {
      final json = driver.toJson()..[DriverJsonKeys.city] = 16;

      expect(() => Driver.fromJson(json), throwsFormatException);
    });
  });

  group('Car', () {
    test('ida e volta no JSON', () {
      expect(Car.fromJson(overTheWire(car.toJson())), car);
    });

    test('tem só id, nome e fotos', () {
      expect(
        car.toJson().keys,
        unorderedEquals(<String>[CarJsonKeys.id, CarJsonKeys.name, CarJsonKeys.photoUrls]),
      );
    });

    test('sem fotos vai como lista vazia', () {
      const bare = Car(id: 'c', name: 'Fusca');

      expect(bare.toJson()[CarJsonKeys.photoUrls], isEmpty);
      expect(Car.fromJson(overTheWire(bare.toJson())), bare);
    });

    test('foto que não é texto lança FormatException', () {
      final json = car.toJson()..[CarJsonKeys.photoUrls] = [1, 2];

      expect(() => Car.fromJson(json), throwsFormatException);
    });

    test('fotos em ordem diferente são carros diferentes', () {
      final reversed = Car(id: car.id, name: car.name, photoUrls: car.photoUrls.reversed.toList());

      expect(reversed, isNot(car));
    });
  });

  group('Duo', () {
    const duo = Duo(id: '019a1b2c-0000-7000-8000-000000000003', driver: driver, car: car);

    test('ida e volta no JSON', () {
      expect(Duo.fromJson(overTheWire(duo.toJson())), duo);
    });

    test('leva o piloto e o carro dentro, sem o contato do piloto', () {
      final json = overTheWire(duo.toJson());
      final driverJson = json[DuoJsonKeys.driver]! as Map<String, Object?>;

      expect(driverJson[DriverJsonKeys.id], driver.id);
      expect(driverJson, isNot(contains(AdminDriverJsonKeys.phone)));
      expect(driverJson, isNot(contains(AdminDriverJsonKeys.email)));
      expect((json[DuoJsonKeys.car]! as Map<String, Object?>)[CarJsonKeys.id], car.id);
    });

    test('carro ausente lança FormatException', () {
      final json = duo.toJson()..remove(DuoJsonKeys.car);

      expect(() => Duo.fromJson(json), throwsFormatException);
    });
  });

  group('RaceEvent', () {
    final event = RaceEvent(
      id: '019a1b2c-0000-7000-8000-000000000004',
      date: DateTime.utc(2026, 12, 5),
      track: 'Autódromo de Ribeirão',
      status: EventStatus.scheduled,
    );

    test('ida e volta no JSON', () {
      expect(RaceEvent.fromJson(overTheWire(event.toJson())), event);
    });

    test('a data vai sem hora', () {
      expect(event.toJson()[RaceEventJsonKeys.date], '2026-12-05');
      expect(event.toJson()[RaceEventJsonKeys.status], 'scheduled');
    });

    test('data local e data UTC do mesmo dia são o mesmo evento', () {
      final local = RaceEvent(
        id: event.id,
        date: DateTime(2026, 12, 5, 21, 30),
        track: event.track,
        status: event.status,
      );

      expect(local, event);
      expect(local.hashCode, event.hashCode);
    });

    test('data com hora ou inválida lança FormatException', () {
      for (final date in ['2026-12-05T10:00:00Z', '2026-13-01', '2026-02-30', '05/12/2026']) {
        final json = event.toJson()..[RaceEventJsonKeys.date] = date;

        expect(() => RaceEvent.fromJson(json), throwsFormatException, reason: date);
      }
    });

    test('status desconhecido lança FormatException', () {
      final json = event.toJson()..[RaceEventJsonKeys.status] = 'cancelled';

      expect(() => RaceEvent.fromJson(json), throwsFormatException);
    });
  });

  group('SiteContent', () {
    const content = SiteContent(
      texts: SiteTexts(about: 'A lista.\n\nOs 10 mais rápidos.', regulation: 'Regra 1.'),
      contacts: SiteContacts(
        whatsapp: '16999990000',
        instagram: 'lista_teste',
        email: 'a@b.invalid',
      ),
    );

    test('ida e volta no JSON', () {
      expect(SiteContent.fromJson(overTheWire(content.toJson())), content);
    });

    test('vazio vai e volta com tudo null', () {
      final json = overTheWire(const SiteContent().toJson());

      expect(json[SiteContentJsonKeys.texts], {
        SiteTextsJsonKeys.about: null,
        SiteTextsJsonKeys.regulation: null,
      });
      expect(SiteContent.fromJson(json), const SiteContent());
    });

    test('textos e contatos aceitam campo ausente', () {
      final json = <String, Object?>{
        SiteContentJsonKeys.texts: <String, Object?>{},
        SiteContentJsonKeys.contacts: <String, Object?>{},
      };

      expect(SiteContent.fromJson(json), const SiteContent());
    });

    test('sem o objeto dos contatos lança FormatException', () {
      final json = {SiteContentJsonKeys.texts: <String, Object?>{}};

      expect(() => SiteContent.fromJson(json), throwsFormatException);
    });

    test('contato que não é texto lança FormatException', () {
      final json = {SiteContactsJsonKeys.whatsapp: 16999990000};

      expect(() => SiteContacts.fromJson(json), throwsFormatException);
    });
  });

  group('Sponsor', () {
    const sponsor = Sponsor(
      id: '019a1b2c-0000-7000-8000-000000000005',
      name: 'Oficina Exemplo',
      logoUrl: 'https://cdn.example/sponsors/5.png',
      linkUrl: 'https://oficina.example',
      position: 2,
    );

    test('ida e volta no JSON', () {
      expect(Sponsor.fromJson(overTheWire(sponsor.toJson())), sponsor);
    });

    test('sem link vai e volta como null', () {
      const bare = Sponsor(
        id: 's',
        name: 'Loja',
        logoUrl: 'https://cdn.example/l.png',
        position: 0,
      );
      final json = overTheWire(bare.toJson());

      expect(json[SponsorJsonKeys.linkUrl], isNull);
      expect(Sponsor.fromJson(json), bare);
    });

    test('posição que não é inteiro lança FormatException', () {
      final json = sponsor.toJson()..[SponsorJsonKeys.position] = '2';

      expect(() => Sponsor.fromJson(json), throwsFormatException);
    });

    test('sem logo lança FormatException', () {
      final json = sponsor.toJson()..remove(SponsorJsonKeys.logoUrl);

      expect(() => Sponsor.fromJson(json), throwsFormatException);
    });
  });
}
