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
}
