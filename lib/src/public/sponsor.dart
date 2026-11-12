import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Sponsor].
abstract final class SponsorJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const logoUrl = 'logoUrl';
  static const linkUrl = 'linkUrl';
  static const description = 'description';
  static const position = 'position';
}

/// Patrocinador da Lista 16, na página "Patrocinadores" (5.4): nome, logo, o link do site dele e
/// um texto opcional de detalhes. Ele não aparece em outra página.
@immutable
final class Sponsor {
  const new({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.position,
    this.linkUrl,
    this.description,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Sponsor.fromJson(JsonMap json) => Sponsor(
    id: readString(json, SponsorJsonKeys.id),
    name: readString(json, SponsorJsonKeys.name),
    logoUrl: readString(json, SponsorJsonKeys.logoUrl),
    linkUrl: readOptionalString(json, SponsorJsonKeys.linkUrl),
    description: readOptionalString(json, SponsorJsonKeys.description),
    position: readInt(json, SponsorJsonKeys.position),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Nome do patrocinador.
  final String name;

  /// Endereço da logo.
  final String logoUrl;

  /// Endereço do site do patrocinador. `null` quando não tem.
  final String? linkUrl;

  /// Texto de detalhes, em texto puro. `null` quando não tem.
  final String? description;

  /// Ordem de exibição: o menor vem primeiro. A API já devolve a lista nessa ordem.
  final int position;

  /// JSON no formato da API. Link e texto sem valor vão como `null`.
  JsonMap toJson() => {
    SponsorJsonKeys.id: id,
    SponsorJsonKeys.name: name,
    SponsorJsonKeys.logoUrl: logoUrl,
    SponsorJsonKeys.linkUrl: linkUrl,
    SponsorJsonKeys.description: description,
    SponsorJsonKeys.position: position,
  };

  @override
  bool operator ==(Object other) =>
      other is Sponsor &&
      other.id == id &&
      other.name == name &&
      other.logoUrl == logoUrl &&
      other.linkUrl == linkUrl &&
      other.description == description &&
      other.position == position;

  @override
  int get hashCode => Object.hash(id, name, logoUrl, linkUrl, description, position);
}
