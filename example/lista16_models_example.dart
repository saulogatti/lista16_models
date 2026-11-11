import 'dart:convert';
import 'dart:io';

import 'package:lista16_models/lista16_models.dart';

void main() {
  const duo = Duo(
    id: '019a1b2c-0000-7000-8000-000000000003',
    driver: Driver(
      id: '019a1b2c-0000-7000-8000-000000000001',
      name: 'João da Silva',
      nickname: 'Joãozinho',
      city: 'Ribeirão Preto',
    ),
    car: Car(id: '019a1b2c-0000-7000-8000-000000000002', name: 'Opalão'),
  );

  // O site recebe a dupla com o piloto público, sem contato.
  final body = jsonEncode(duo.toJson());
  stdout.writeln(body);

  final parsed = Duo.fromJson(jsonDecode(body) as Map<String, Object?>);
  stdout.writeln('${parsed.driver.nickname} com ${parsed.car.name}');

  // O painel recebe o piloto com telefone e e-mail.
  final admin = AdminDriver(profile: parsed.driver, phone: '16999990000');
  stdout.writeln(jsonEncode(admin.toJson()));
}
