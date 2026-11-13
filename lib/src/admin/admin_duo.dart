import 'package:lista16_models/src/admin/admin_driver.dart';
import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/car.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:meta/meta.dart';

/// Chaves JSON que [AdminDuo] acrescenta às de [DuoJsonKeys].
abstract final class AdminDuoJsonKeys {
  static const position = 'position';
}

/// Chaves do corpo com que o painel cria (`POST`) e edita (`PUT`) uma dupla.
///
/// O corpo tem o piloto e o carro inteiros, sem os ids: `{driver, car, showsHistory}`, e no
/// `PUT` também `leaveLadder`. O piloto vai com as chaves de [AdminDriver] (as de
/// `DriverJsonKeys` mais telefone e e-mail) e o carro com as de [Car]. A API grava os três de
/// uma vez.
abstract final class DuoInputJsonKeys {
  static const driver = 'driver';
  static const car = 'car';
  static const showsHistory = 'showsHistory';

  /// Só no `PUT` da dupla que está na lista: `true` tira a dupla da lista ao salvar (1.2).
  /// Quem estava abaixo sobe, a dupla antiga fica guardada com o histórico e os dados editados
  /// viram uma dupla nova, fora da lista. `false` só atualiza os dados.
  static const leaveLadder = 'leaveLadder';
}

/// Dupla como o painel recebe: o piloto com o contato, o carro, a marca do histórico e a
/// posição na lista.
///
/// No JSON o piloto e o carro vêm aninhados, como em [Duo]:
/// `{id, driver: {...}, car: {...}, showsHistory, position}`.
@immutable
final class AdminDuo {
  const new({
    required this.id,
    required this.driver,
    required this.car,
    this.showsHistory = false,
    this.position,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminDuo.fromJson(JsonMap json) => AdminDuo(
    id: readString(json, DuoJsonKeys.id),
    driver: AdminDriver.fromJson(readMap(json, DuoJsonKeys.driver)),
    car: Car.fromJson(readMap(json, DuoJsonKeys.car)),
    showsHistory: readBool(json, DuoJsonKeys.showsHistory),
    position: readOptionalInt(json, AdminDuoJsonKeys.position),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Piloto, com o contato que só o painel vê.
  final AdminDriver driver;

  /// Carro da dupla.
  final Car car;

  /// Se o site mostra o histórico de desafios da dupla (5.3).
  final bool showsHistory;

  /// Posição na lista, de 1 a 10, ou `null` se a dupla está fora. Calculada pela API.
  final int? position;

  /// A mesma dupla sem o contato do piloto.
  Duo get public => Duo(id: id, driver: driver.profile, car: car, showsHistory: showsHistory);

  /// JSON no formato da API.
  JsonMap toJson() => {
    DuoJsonKeys.id: id,
    DuoJsonKeys.driver: driver.toJson(),
    DuoJsonKeys.car: car.toJson(),
    DuoJsonKeys.showsHistory: showsHistory,
    AdminDuoJsonKeys.position: position,
  };

  @override
  bool operator ==(Object other) =>
      other is AdminDuo &&
      other.id == id &&
      other.driver == driver &&
      other.car == car &&
      other.showsHistory == showsHistory &&
      other.position == position;

  @override
  int get hashCode => Object.hash(id, driver, car, showsHistory, position);
}
