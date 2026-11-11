import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Driver].
abstract final class DriverJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const nickname = 'nickname';
  static const city = 'city';
  static const photoUrl = 'photoUrl';
  static const logoUrl = 'logoUrl';
}

/// Piloto como o site mostra (5.1): nome, apelido, cidade, foto e a logo do banner.
///
/// Não tem contato (telefone, e-mail): isso fica em `AdminDriver`, só no painel.
@immutable
final class Driver {
  const new({
    required this.id,
    required this.name,
    required this.nickname,
    required this.city,
    this.photoUrl,
    this.logoUrl,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Driver.fromJson(JsonMap json) => Driver(
    id: readString(json, DriverJsonKeys.id),
    name: readString(json, DriverJsonKeys.name),
    nickname: readString(json, DriverJsonKeys.nickname),
    city: readString(json, DriverJsonKeys.city),
    photoUrl: readOptionalString(json, DriverJsonKeys.photoUrl),
    logoUrl: readOptionalString(json, DriverJsonKeys.logoUrl),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Nome do piloto.
  final String name;

  /// Apelido do piloto.
  final String nickname;

  /// Cidade do piloto. Só entra quem é de cidade com DDD 16 (1.5); a API é quem confere.
  final String city;

  /// Endereço da foto do piloto. `null` enquanto o piloto não mandou a foto (5.5).
  final String? photoUrl;

  /// Endereço da logo do piloto, mostrada num banner. Só quando o piloto tem logo (5.1).
  final String? logoUrl;

  /// JSON no formato da API. Campo opcional sem valor vai como `null`.
  JsonMap toJson() => {
    DriverJsonKeys.id: id,
    DriverJsonKeys.name: name,
    DriverJsonKeys.nickname: nickname,
    DriverJsonKeys.city: city,
    DriverJsonKeys.photoUrl: photoUrl,
    DriverJsonKeys.logoUrl: logoUrl,
  };

  @override
  bool operator ==(Object other) =>
      other is Driver &&
      other.id == id &&
      other.name == name &&
      other.nickname == nickname &&
      other.city == city &&
      other.photoUrl == photoUrl &&
      other.logoUrl == logoUrl;

  @override
  int get hashCode => Object.hash(id, name, nickname, city, photoUrl, logoUrl);
}
