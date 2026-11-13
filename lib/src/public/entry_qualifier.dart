import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/enums/race_outcome.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [QualifierPairing].
abstract final class QualifierPairingJsonKeys {
  static const id = 'id';
  static const first = 'first';
  static const second = 'second';
  static const winnerId = 'winnerId';
  static const outcome = 'outcome';
  static const firstReactionMs = 'firstReactionMs';
  static const secondReactionMs = 'secondReactionMs';
}

/// Confronto de uma rodada da disputa de entrada: uma corrida sem posição em jogo (2.2).
@immutable
final class QualifierPairing {
  const new({
    required this.id,
    required this.first,
    required this.second,
    this.winnerId,
    this.outcome,
    this.firstReactionMs,
    this.secondReactionMs,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory QualifierPairing.fromJson(JsonMap json) => QualifierPairing(
    id: readString(json, QualifierPairingJsonKeys.id),
    first: Duo.fromJson(readMap(json, QualifierPairingJsonKeys.first)),
    second: Duo.fromJson(readMap(json, QualifierPairingJsonKeys.second)),
    winnerId: readOptionalString(json, QualifierPairingJsonKeys.winnerId),
    outcome: switch (json[QualifierPairingJsonKeys.outcome]) {
      null => null,
      final value => RaceOutcome.fromJson(value),
    },
    firstReactionMs: readOptionalInt(json, QualifierPairingJsonKeys.firstReactionMs),
    secondReactionMs: readOptionalInt(json, QualifierPairingJsonKeys.secondReactionMs),
  );

  /// Identificador do confronto.
  final String id;

  /// Dupla sorteada em primeiro lugar.
  final Duo first;

  /// Dupla sorteada contra [first].
  final Duo second;

  /// Id de quem venceu; `null` enquanto a corrida não foi lançada.
  final String? winnerId;

  /// Por que o vencedor venceu; `null` enquanto a corrida não foi lançada.
  final RaceOutcome? outcome;

  /// Reação de [first] na largada, em milissegundos (3.6).
  final int? firstReactionMs;

  /// Reação de [second] na largada, em milissegundos (3.6).
  final int? secondReactionMs;

  /// JSON no formato da API.
  JsonMap toJson() => {
    QualifierPairingJsonKeys.id: id,
    QualifierPairingJsonKeys.first: first.toJson(),
    QualifierPairingJsonKeys.second: second.toJson(),
    QualifierPairingJsonKeys.winnerId: winnerId,
    QualifierPairingJsonKeys.outcome: outcome?.toJson(),
    QualifierPairingJsonKeys.firstReactionMs: firstReactionMs,
    QualifierPairingJsonKeys.secondReactionMs: secondReactionMs,
  };

  @override
  bool operator ==(Object other) =>
      other is QualifierPairing &&
      other.id == id &&
      other.first == first &&
      other.second == second &&
      other.winnerId == winnerId &&
      other.outcome == outcome &&
      other.firstReactionMs == firstReactionMs &&
      other.secondReactionMs == secondReactionMs;

  @override
  int get hashCode =>
      Object.hash(id, first, second, winnerId, outcome, firstReactionMs, secondReactionMs);
}

/// Chaves JSON de [QualifierRound].
abstract final class QualifierRoundJsonKeys {
  static const number = 'number';
  static const pairings = 'pairings';
  static const bye = 'bye';
}

/// Rodada sorteada da disputa de entrada (2.2).
@immutable
final class QualifierRound {
  const new({required this.number, required this.pairings, this.bye});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory QualifierRound.fromJson(JsonMap json) => QualifierRound(
    number: readInt(json, QualifierRoundJsonKeys.number),
    pairings: readObjectList(json, QualifierRoundJsonKeys.pairings, QualifierPairing.fromJson),
    bye: switch (readOptionalMap(json, QualifierRoundJsonKeys.bye)) {
      null => null,
      final map => Duo.fromJson(map),
    },
  );

  /// Número da rodada, a partir de 1.
  final int number;

  /// Confrontos sorteados.
  final List<QualifierPairing> pairings;

  /// Quem passou direto (W.O.) por sorteio, com número ímpar de candidatos. Aparece na história
  /// (2.2).
  final Duo? bye;

  /// JSON no formato da API.
  JsonMap toJson() => {
    QualifierRoundJsonKeys.number: number,
    QualifierRoundJsonKeys.pairings: [for (final p in pairings) p.toJson()],
    QualifierRoundJsonKeys.bye: bye?.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is QualifierRound &&
      other.number == number &&
      listEquals(other.pairings, pairings) &&
      other.bye == bye;

  @override
  int get hashCode => Object.hash(number, Object.hashAll(pairings), bye);
}

/// Chaves JSON de [EntryQualifier].
abstract final class EntryQualifierJsonKeys {
  static const id = 'id';
  static const eventId = 'eventId';
  static const candidates = 'candidates';
  static const rounds = 'rounds';
  static const winnerId = 'winnerId';
  static const challengeId = 'challengeId';
}

/// Disputa de entrada entre os candidatos de fora da lista (2.2). Aparece no site, nos eventos
/// (1.3).
///
/// Com um candidato só, não há rodada: ele já é o vencedor e desafia o 10º.
@immutable
final class EntryQualifier {
  const new({
    required this.id,
    required this.eventId,
    required this.candidates,
    required this.rounds,
    this.winnerId,
    this.challengeId,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory EntryQualifier.fromJson(JsonMap json) => EntryQualifier(
    id: readString(json, EntryQualifierJsonKeys.id),
    eventId: readString(json, EntryQualifierJsonKeys.eventId),
    candidates: readObjectList(json, EntryQualifierJsonKeys.candidates, Duo.fromJson),
    rounds: readObjectList(json, EntryQualifierJsonKeys.rounds, QualifierRound.fromJson),
    winnerId: readOptionalString(json, EntryQualifierJsonKeys.winnerId),
    challengeId: readOptionalString(json, EntryQualifierJsonKeys.challengeId),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Evento da disputa.
  final String eventId;

  /// Candidatos inscritos, todos de fora da lista.
  final List<Duo> candidates;

  /// Rodadas sorteadas até agora. Sem vencedor, a última é a rodada em andamento.
  final List<QualifierRound> rounds;

  /// Id de quem venceu e desafia o 10º; `null` enquanto a disputa não terminou.
  final String? winnerId;

  /// Desafio de entrada que o vencedor lançou contra o 10º; `null` antes disso.
  final String? challengeId;

  /// Se a disputa já tem vencedor.
  bool get isFinished => winnerId != null;

  /// JSON no formato da API.
  JsonMap toJson() => {
    EntryQualifierJsonKeys.id: id,
    EntryQualifierJsonKeys.eventId: eventId,
    EntryQualifierJsonKeys.candidates: [for (final duo in candidates) duo.toJson()],
    EntryQualifierJsonKeys.rounds: [for (final round in rounds) round.toJson()],
    EntryQualifierJsonKeys.winnerId: winnerId,
    EntryQualifierJsonKeys.challengeId: challengeId,
  };

  @override
  bool operator ==(Object other) =>
      other is EntryQualifier &&
      other.id == id &&
      other.eventId == eventId &&
      listEquals(other.candidates, candidates) &&
      listEquals(other.rounds, rounds) &&
      other.winnerId == winnerId &&
      other.challengeId == challengeId;

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    Object.hashAll(candidates),
    Object.hashAll(rounds),
    winnerId,
    challengeId,
  );
}
