import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/driver.dart';
import 'package:meta/meta.dart';

/// Chaves JSON que [AdminDriver] acrescenta às de [DriverJsonKeys].
abstract final class AdminDriverJsonKeys {
  static const phone = 'phone';
  static const email = 'email';
}

/// Piloto como o painel recebe: os dados públicos ([profile]) mais o contato.
///
/// O contato nunca vai para o site (5.1). No JSON os campos ficam no mesmo nível, sem
/// objeto aninhado: `{id, name, nickname, city, photoUrl, logoUrl, phone, email}`.
@immutable
final class AdminDriver {
  const new({required this.profile, required this.phone, this.email});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminDriver.fromJson(JsonMap json) => AdminDriver(
    profile: Driver.fromJson(json),
    phone: readString(json, AdminDriverJsonKeys.phone),
    email: readOptionalString(json, AdminDriverJsonKeys.email),
  );

  /// Dados que o site também mostra.
  final Driver profile;

  /// Telefone do piloto, com WhatsApp. Todo piloto tem (5.1). Só o painel vê.
  final String phone;

  /// E-mail do piloto. Só o painel vê.
  final String? email;

  /// JSON no formato da API: os campos de [profile] mais o contato.
  JsonMap toJson() => {
    ...profile.toJson(),
    AdminDriverJsonKeys.phone: phone,
    AdminDriverJsonKeys.email: email,
  };

  @override
  bool operator ==(Object other) =>
      other is AdminDriver &&
      other.profile == profile &&
      other.phone == phone &&
      other.email == email;

  @override
  int get hashCode => Object.hash(profile, phone, email);
}
