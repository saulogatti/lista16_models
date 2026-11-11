import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/car.dart';
import 'package:lista16_models/src/public/driver.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Duo].
abstract final class DuoJsonKeys {
  static const id = 'id';
  static const driver = 'driver';
  static const car = 'car';
}

/// Dupla piloto + carro. É a dupla que ocupa a posição na lista (1.1).
///
/// A posição não fica aqui: o ranking sai dos movimentos da lista, calculado pela API.
///
/// Não decide o que acontece quando o piloto troca de carro (1.2): se vira outra dupla ou se a
/// mesma dupla muda de carro ainda é dúvida com o dono.
@immutable
final class Duo {
  const new({required this.id, required this.driver, required this.car});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Duo.fromJson(JsonMap json) => Duo(
    id: readString(json, DuoJsonKeys.id),
    driver: Driver.fromJson(readMap(json, DuoJsonKeys.driver)),
    car: Car.fromJson(readMap(json, DuoJsonKeys.car)),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Piloto da dupla, só com os dados públicos.
  final Driver driver;

  /// Carro da dupla.
  final Car car;

  /// JSON no formato da API, com o piloto e o carro dentro.
  JsonMap toJson() => {
    DuoJsonKeys.id: id,
    DuoJsonKeys.driver: driver.toJson(),
    DuoJsonKeys.car: car.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is Duo && other.id == id && other.driver == driver && other.car == car;

  @override
  int get hashCode => Object.hash(id, driver, car);
}
