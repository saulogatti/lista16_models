import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/workshop.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Car].
abstract final class CarJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const photoUrls = 'photoUrls';
  static const workshop = 'workshop';
  static const showsHistory = 'showsHistory';
}

/// Carro como o site mostra (5.2): um nome, as fotos e a oficina que o prepara.
///
/// Sem marca, modelo, ano, dados técnicos nem placa.
@immutable
final class Car {
  const new({
    required this.id,
    required this.name,
    this.photoUrls = const [],
    this.workshop,
    this.showsHistory = false,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Car.fromJson(JsonMap json) => Car(
    id: readString(json, CarJsonKeys.id),
    name: readString(json, CarJsonKeys.name),
    photoUrls: readStringList(json, CarJsonKeys.photoUrls),
    workshop: switch (readOptionalMap(json, CarJsonKeys.workshop)) {
      final workshop? => Workshop.fromJson(workshop),
      null => null,
    },
    // Ausente vale `false`: o histórico só aparece quando a organização liga.
    showsHistory:
        json[CarJsonKeys.showsHistory] != null && readBool(json, CarJsonKeys.showsHistory),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Nome ou apelido do carro.
  final String name;

  /// Endereços das fotos do carro, na ordem de exibição. Vazia enquanto não chegou foto.
  final List<String> photoUrls;

  /// Oficina que prepara o carro, ou `null` se não foi cadastrada.
  final Workshop? workshop;

  /// Se o site mostra o histórico de desafios das duplas deste carro. A organização escolhe
  /// quais carros mostram (5.3).
  final bool showsHistory;

  /// JSON no formato da API. Sem oficina vai como `null`.
  JsonMap toJson() => {
    CarJsonKeys.id: id,
    CarJsonKeys.name: name,
    CarJsonKeys.photoUrls: photoUrls,
    CarJsonKeys.workshop: workshop?.toJson(),
    CarJsonKeys.showsHistory: showsHistory,
  };

  @override
  bool operator ==(Object other) =>
      other is Car &&
      other.id == id &&
      other.name == name &&
      listEquals(other.photoUrls, photoUrls) &&
      other.workshop == workshop &&
      other.showsHistory == showsHistory;

  @override
  int get hashCode => Object.hash(id, name, Object.hashAll(photoUrls), workshop, showsHistory);
}
