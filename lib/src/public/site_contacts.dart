import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [SiteContacts].
abstract final class SiteContactsJsonKeys {
  static const whatsapp = 'whatsapp';
  static const instagram = 'instagram';
  static const email = 'email';
}

/// Contatos da organização da Lista 16 na página "Contato" (5.4): WhatsApp, Instagram e e-mail.
///
/// São públicos. Não é o contato do piloto, que fica só no painel (`AdminDriver`). Canal ainda
/// sem valor fica `null` e o site mostra "em breve" nele.
@immutable
final class SiteContacts {
  const new({this.whatsapp, this.instagram, this.email});

  /// Lê o JSON da API; lança [FormatException] se o tipo não bater.
  factory SiteContacts.fromJson(JsonMap json) => SiteContacts(
    whatsapp: readOptionalString(json, SiteContactsJsonKeys.whatsapp),
    instagram: readOptionalString(json, SiteContactsJsonKeys.instagram),
    email: readOptionalString(json, SiteContactsJsonKeys.email),
  );

  /// Número do WhatsApp só com dígitos, com DDD e sem o código do país (ex.: `16999990000`).
  final String? whatsapp;

  /// Usuário do Instagram, sem o `@`.
  final String? instagram;

  /// Endereço de e-mail.
  final String? email;

  /// JSON no formato da API. Canal sem valor vai como `null`.
  JsonMap toJson() => {
    SiteContactsJsonKeys.whatsapp: whatsapp,
    SiteContactsJsonKeys.instagram: instagram,
    SiteContactsJsonKeys.email: email,
  };

  @override
  bool operator ==(Object other) =>
      other is SiteContacts &&
      other.whatsapp == whatsapp &&
      other.instagram == instagram &&
      other.email == email;

  @override
  int get hashCode => Object.hash(whatsapp, instagram, email);
}
