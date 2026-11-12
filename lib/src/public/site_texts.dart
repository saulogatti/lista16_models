import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [SiteTexts].
abstract final class SiteTextsJsonKeys {
  static const about = 'about';
  static const regulation = 'regulation';
}

/// Textos das páginas "Sobre" e "Regulamento" do site (5.4).
///
/// Texto puro, sem formatação: cada linha em branco separa um parágrafo. O texto é do dono da
/// lista; enquanto não chega, fica `null` e o site mostra "em breve".
@immutable
final class SiteTexts {
  const new({this.about, this.regulation});

  /// Lê o JSON da API; lança [FormatException] se o tipo não bater.
  factory SiteTexts.fromJson(JsonMap json) => SiteTexts(
    about: readOptionalString(json, SiteTextsJsonKeys.about),
    regulation: readOptionalString(json, SiteTextsJsonKeys.regulation),
  );

  /// Texto da página "Sobre".
  final String? about;

  /// Texto do regulamento (5.4: só texto, de no máximo 2 páginas).
  final String? regulation;

  /// JSON no formato da API. Texto sem valor vai como `null`.
  JsonMap toJson() => {SiteTextsJsonKeys.about: about, SiteTextsJsonKeys.regulation: regulation};

  @override
  bool operator ==(Object other) =>
      other is SiteTexts && other.about == about && other.regulation == regulation;

  @override
  int get hashCode => Object.hash(about, regulation);
}
