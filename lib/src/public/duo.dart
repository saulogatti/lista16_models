import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/car.dart';
import 'package:lista16_models/src/public/driver.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Duo].
abstract final class DuoJsonKeys {
  static const id = 'id';
  static const driver = 'driver';
  static const car = 'car';
  static const showsHistory = 'showsHistory';
}

/// Dupla piloto + carro. É a dupla que ocupa a posição na lista (1.1).
///
/// Um piloto e um carro estão numa dupla ativa só (1.2). Mudou o carro ou o piloto e a dupla
/// saiu da lista: a API guarda a dupla antiga, com o histórico, e os dados novos viram outra
/// dupla, com outro id.
///
/// A posição não fica aqui: o ranking sai dos movimentos da lista, calculado pela API.
@immutable
final class Duo {
  const new({required this.id, required this.driver, required this.car, this.showsHistory = false});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Duo.fromJson(JsonMap json) => Duo(
    id: readString(json, DuoJsonKeys.id),
    driver: Driver.fromJson(readMap(json, DuoJsonKeys.driver)),
    car: Car.fromJson(readMap(json, DuoJsonKeys.car)),
    // Ausente vale `false`: o histórico só aparece quando a organização liga.
    showsHistory:
        json[DuoJsonKeys.showsHistory] != null && readBool(json, DuoJsonKeys.showsHistory),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Piloto da dupla, só com os dados públicos.
  final Driver driver;

  /// Carro da dupla.
  final Car car;

  /// Se o site mostra o histórico de desafios da dupla. A organização escolhe quais mostram, e
  /// o histórico é da dupla: o carro que vai para outro piloto não o leva (5.3).
  final bool showsHistory;

  /// JSON no formato da API, com o piloto e o carro dentro.
  JsonMap toJson() => {
    DuoJsonKeys.id: id,
    DuoJsonKeys.driver: driver.toJson(),
    DuoJsonKeys.car: car.toJson(),
    DuoJsonKeys.showsHistory: showsHistory,
  };

  @override
  bool operator ==(Object other) =>
      other is Duo &&
      other.id == id &&
      other.driver == driver &&
      other.car == car &&
      other.showsHistory == showsHistory;

  @override
  int get hashCode => Object.hash(id, driver, car, showsHistory);
}
