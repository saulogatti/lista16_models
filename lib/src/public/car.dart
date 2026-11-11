import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Car].
abstract final class CarJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const photoUrls = 'photoUrls';
}

/// Carro como o site mostra (5.2): um nome e as fotos.
///
/// Sem marca, modelo, ano, dados técnicos nem placa.
@immutable
final class Car {
  const new({required this.id, required this.name, this.photoUrls = const []});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Car.fromJson(JsonMap json) => Car(
    id: readString(json, CarJsonKeys.id),
    name: readString(json, CarJsonKeys.name),
    photoUrls: readStringList(json, CarJsonKeys.photoUrls),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Nome ou apelido do carro.
  final String name;

  /// Endereços das fotos do carro, na ordem de exibição. Vazia enquanto não chegou foto.
  final List<String> photoUrls;

  /// JSON no formato da API.
  JsonMap toJson() => {
    CarJsonKeys.id: id,
    CarJsonKeys.name: name,
    CarJsonKeys.photoUrls: photoUrls,
  };

  @override
  bool operator ==(Object other) =>
      other is Car &&
      other.id == id &&
      other.name == name &&
      listEquals(other.photoUrls, photoUrls);

  @override
  int get hashCode => Object.hash(id, name, Object.hashAll(photoUrls));
}
