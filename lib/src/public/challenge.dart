import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/enums/challenge_kind.dart';
import 'package:lista16_models/src/enums/challenge_origin.dart';
import 'package:lista16_models/src/enums/challenge_status.dart';
import 'package:lista16_models/src/enums/race_outcome.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Challenge].
abstract final class ChallengeJsonKeys {
  static const id = 'id';
  static const kind = 'kind';
  static const challenger = 'challenger';
  static const challenged = 'challenged';
  static const position = 'position';
  static const eventId = 'eventId';
  static const origin = 'origin';
  static const status = 'status';
  static const launchedOn = 'launchedOn';
  static const closedOn = 'closedOn';
  static const outcome = 'outcome';
  static const winnerId = 'winnerId';
  static const challengerReactionMs = 'challengerReactionMs';
  static const challengedReactionMs = 'challengedReactionMs';
}

/// Desafio entre duas duplas, como o site mostra na agenda e na história (2.7).
///
/// Da corrida, só a reação na largada é pública (3.6): os outros tempos não existem neste
/// modelo.
@immutable
final class Challenge {
  const new({
    required this.id,
    required this.kind,
    required this.challenger,
    required this.challenged,
    required this.position,
    required this.origin,
    required this.status,
    required this.launchedOn,
    this.eventId,
    this.closedOn,
    this.outcome,
    this.winnerId,
    this.challengerReactionMs,
    this.challengedReactionMs,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Challenge.fromJson(JsonMap json) => Challenge(
    id: readString(json, ChallengeJsonKeys.id),
    kind: ChallengeKind.fromJson(json[ChallengeJsonKeys.kind]),
    challenger: Duo.fromJson(readMap(json, ChallengeJsonKeys.challenger)),
    challenged: Duo.fromJson(readMap(json, ChallengeJsonKeys.challenged)),
    position: readInt(json, ChallengeJsonKeys.position),
    origin: ChallengeOrigin.fromJson(json[ChallengeJsonKeys.origin]),
    status: ChallengeStatus.fromJson(json[ChallengeJsonKeys.status]),
    launchedOn: readDate(json, ChallengeJsonKeys.launchedOn),
    eventId: readOptionalString(json, ChallengeJsonKeys.eventId),
    closedOn: readOptionalDate(json, ChallengeJsonKeys.closedOn),
    outcome: switch (json[ChallengeJsonKeys.outcome]) {
      null => null,
      final value => RaceOutcome.fromJson(value),
    },
    winnerId: readOptionalString(json, ChallengeJsonKeys.winnerId),
    challengerReactionMs: readOptionalInt(json, ChallengeJsonKeys.challengerReactionMs),
    challengedReactionMs: readOptionalInt(json, ChallengeJsonKeys.challengedReactionMs),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Por posição (2.1) ou de entrada (2.2).
  final ChallengeKind kind;

  /// Quem desafia: a dupla logo abaixo, ou o vencedor da disputa de entrada.
  final Duo challenger;

  /// Quem é desafiado: a dupla logo acima, ou o 10º.
  final Duo challenged;

  /// Posição em jogo: a do desafiado quando o desafio foi lançado.
  final int position;

  /// Evento em que o desafio deve ser corrido; `null` enquanto a organização não marcou.
  final String? eventId;

  /// Marcado antes do evento ou feito nele (2.7).
  final ChallengeOrigin origin;

  /// Pendente, decidido ou cancelado.
  final ChallengeStatus status;

  /// Dia em que o desafio foi lançado.
  final DateTime launchedOn;

  /// Dia em que foi decidido ou cancelado; `null` enquanto está pendente.
  final DateTime? closedOn;

  /// Por que o vencedor venceu; `null` enquanto não há resultado.
  final RaceOutcome? outcome;

  /// Id da dupla vencedora; `null` enquanto não há resultado.
  final String? winnerId;

  /// Reação do desafiante na largada, em milissegundos; negativa é queima (3.3). `null` quando
  /// não correu.
  final int? challengerReactionMs;

  /// Reação do desafiado na largada, em milissegundos. `null` quando não correu.
  final int? challengedReactionMs;

  /// JSON no formato da API.
  JsonMap toJson() => {
    ChallengeJsonKeys.id: id,
    ChallengeJsonKeys.kind: kind.toJson(),
    ChallengeJsonKeys.challenger: challenger.toJson(),
    ChallengeJsonKeys.challenged: challenged.toJson(),
    ChallengeJsonKeys.position: position,
    ChallengeJsonKeys.eventId: eventId,
    ChallengeJsonKeys.origin: origin.toJson(),
    ChallengeJsonKeys.status: status.toJson(),
    ChallengeJsonKeys.launchedOn: writeDate(launchedOn),
    ChallengeJsonKeys.closedOn: closedOn == null ? null : writeDate(closedOn!),
    ChallengeJsonKeys.outcome: outcome?.toJson(),
    ChallengeJsonKeys.winnerId: winnerId,
    ChallengeJsonKeys.challengerReactionMs: challengerReactionMs,
    ChallengeJsonKeys.challengedReactionMs: challengedReactionMs,
  };

  @override
  bool operator ==(Object other) =>
      other is Challenge &&
      other.id == id &&
      other.kind == kind &&
      other.challenger == challenger &&
      other.challenged == challenged &&
      other.position == position &&
      other.eventId == eventId &&
      other.origin == origin &&
      other.status == status &&
      writeDate(other.launchedOn) == writeDate(launchedOn) &&
      other._closedOnText == _closedOnText &&
      other.outcome == outcome &&
      other.winnerId == winnerId &&
      other.challengerReactionMs == challengerReactionMs &&
      other.challengedReactionMs == challengedReactionMs;

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    challenger,
    challenged,
    position,
    eventId,
    origin,
    status,
    writeDate(launchedOn),
    _closedOnText,
    outcome,
    winnerId,
    challengerReactionMs,
    challengedReactionMs,
  );

  String? get _closedOnText => closedOn == null ? null : writeDate(closedOn!);
}
