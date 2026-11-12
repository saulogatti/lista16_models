import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/site_contacts.dart';
import 'package:lista16_models/src/public/site_texts.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [SiteContent].
abstract final class SiteContentJsonKeys {
  static const texts = 'texts';
  static const contacts = 'contacts';
}

/// O conteúdo das páginas fixas do site, de uma vez: os textos e os contatos da organização.
@immutable
final class SiteContent {
  const new({this.texts = const SiteTexts(), this.contacts = const SiteContacts()});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory SiteContent.fromJson(JsonMap json) => SiteContent(
    texts: SiteTexts.fromJson(readMap(json, SiteContentJsonKeys.texts)),
    contacts: SiteContacts.fromJson(readMap(json, SiteContentJsonKeys.contacts)),
  );

  /// Textos das páginas "Sobre" e "Regulamento".
  final SiteTexts texts;

  /// Contatos da organização.
  final SiteContacts contacts;

  /// JSON no formato da API.
  JsonMap toJson() => {
    SiteContentJsonKeys.texts: texts.toJson(),
    SiteContentJsonKeys.contacts: contacts.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is SiteContent && other.texts == texts && other.contacts == contacts;

  @override
  int get hashCode => Object.hash(texts, contacts);
}
