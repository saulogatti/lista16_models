import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/challenge.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:lista16_models/src/public/ladder_entry.dart';
import 'package:lista16_models/src/public/race_event.dart';
import 'package:lista16_models/src/public/site_content.dart';
import 'package:lista16_models/src/public/sponsor.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [PublishedData].
abstract final class PublishedDataJsonKeys {
  static const formatVersion = 'formatVersion';
  static const publishedAt = 'publishedAt';
  static const mediaBaseUrl = 'mediaBaseUrl';
  static const duos = 'duos';
  static const events = 'events';
  static const content = 'content';
  static const sponsors = 'sponsors';
  static const ladder = 'ladder';
  static const challenges = 'challenges';
  static const history = 'history';
}

/// Os dados que o site publicou, num arquivo só, para quem mostra o mesmo que o site (o app).
///
/// O build do site grava este arquivo com a mesma leitura da API que gera as páginas. Por
/// isso ele muda só quando o site é publicado, e não a cada edição no painel, como as rotas
/// `/api/v1/public`. Só tem os tipos públicos: nada de contato do piloto nem tempo de corrida.
///
/// Acrescentar campo não muda [formatVersion]. Quebrar o formato muda a versão e o endereço do
/// arquivo, para quem lê a versão velha continuar funcionando.
@immutable
final class PublishedData {
  const new({
    required this.publishedAt,
    required this.mediaBaseUrl,
    this.duos = const [],
    this.events = const [],
    this.content = const SiteContent(),
    this.sponsors = const [],
    this.ladder = const [],
    this.challenges = const [],
    this.history = const [],
  });

  /// Lê o JSON do arquivo publicado; lança [FormatException] se faltar campo, o tipo não bater
  /// ou a versão do formato não for [currentFormatVersion].
  factory PublishedData.fromJson(JsonMap json) {
    final version = readInt(json, PublishedDataJsonKeys.formatVersion);
    if (version != currentFormatVersion) {
      throw FormatException('Versão do formato desconhecida: $version');
    }
    return PublishedData(
      publishedAt: readDateTime(json, PublishedDataJsonKeys.publishedAt),
      mediaBaseUrl: readString(json, PublishedDataJsonKeys.mediaBaseUrl),
      duos: readObjectList(json, PublishedDataJsonKeys.duos, Duo.fromJson),
      events: readObjectList(json, PublishedDataJsonKeys.events, RaceEvent.fromJson),
      content: SiteContent.fromJson(readMap(json, PublishedDataJsonKeys.content)),
      sponsors: readObjectList(json, PublishedDataJsonKeys.sponsors, Sponsor.fromJson),
      ladder: readObjectList(json, PublishedDataJsonKeys.ladder, LadderEntry.fromJson),
      challenges: readObjectList(json, PublishedDataJsonKeys.challenges, Challenge.fromJson),
      history: readObjectList(json, PublishedDataJsonKeys.history, Challenge.fromJson),
    );
  }

  /// Versão do formato que este pacote escreve e lê.
  static const currentFormatVersion = 1;

  /// Quando o build do site leu a API, em UTC.
  final DateTime publishedAt;

  /// Endereço da API, sem a barra no fim. O caminho de cada foto (`PhotoSize.path`) é a partir
  /// dele.
  final String mediaBaseUrl;

  /// As duplas em atividade, como em `/api/v1/public/duos`. Não é a lista: a lista é [ladder].
  final List<Duo> duos;

  /// A agenda, do evento mais próximo para o mais distante.
  final List<RaceEvent> events;

  /// Textos das páginas fixas e contatos da organização.
  final SiteContent content;

  /// Patrocinadores, na ordem de exibição.
  final List<Sponsor> sponsors;

  /// A lista, da 1ª posição para baixo. Pode ter menos de 10.
  final List<LadderEntry> ladder;

  /// Desafios pendentes, para a agenda.
  final List<Challenge> challenges;

  /// Desafios com corrida das duplas que a organização marcou para mostrar o histórico, do mais
  /// recente para o mais antigo. Da corrida, só a reação.
  final List<Challenge> history;

  /// JSON do arquivo publicado.
  JsonMap toJson() => {
    PublishedDataJsonKeys.formatVersion: currentFormatVersion,
    PublishedDataJsonKeys.publishedAt: writeDateTime(publishedAt),
    PublishedDataJsonKeys.mediaBaseUrl: mediaBaseUrl,
    PublishedDataJsonKeys.duos: [for (final duo in duos) duo.toJson()],
    PublishedDataJsonKeys.events: [for (final event in events) event.toJson()],
    PublishedDataJsonKeys.content: content.toJson(),
    PublishedDataJsonKeys.sponsors: [for (final sponsor in sponsors) sponsor.toJson()],
    PublishedDataJsonKeys.ladder: [for (final entry in ladder) entry.toJson()],
    PublishedDataJsonKeys.challenges: [for (final challenge in challenges) challenge.toJson()],
    PublishedDataJsonKeys.history: [for (final challenge in history) challenge.toJson()],
  };

  @override
  bool operator ==(Object other) =>
      other is PublishedData &&
      other.publishedAt == publishedAt &&
      other.mediaBaseUrl == mediaBaseUrl &&
      listEquals(other.duos, duos) &&
      listEquals(other.events, events) &&
      other.content == content &&
      listEquals(other.sponsors, sponsors) &&
      listEquals(other.ladder, ladder) &&
      listEquals(other.challenges, challenges) &&
      listEquals(other.history, history);

  @override
  int get hashCode => Object.hash(
    publishedAt,
    mediaBaseUrl,
    Object.hashAll(duos),
    Object.hashAll(events),
    content,
    Object.hashAll(sponsors),
    Object.hashAll(ladder),
    Object.hashAll(challenges),
    Object.hashAll(history),
  );
}
