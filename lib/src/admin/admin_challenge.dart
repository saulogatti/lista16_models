import 'package:lista16_models/src/admin/admin_enums.dart';
import 'package:lista16_models/src/admin/admin_race_run.dart';
import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/challenge.dart';
import 'package:meta/meta.dart';

/// Chaves JSON que [AdminChallenge] acrescenta às de [ChallengeJsonKeys].
abstract final class AdminChallengeJsonKeys {
  static const actions = 'actions';
  static const runs = 'runs';
  static const tiebreak = 'tiebreak';
  static const deadlineEvents = 'deadlineEvents';
}

/// Desafio como o painel recebe: o público ([challenge]), os tempos guardados e as ações que a
/// API libera agora.
///
/// No JSON os campos ficam no mesmo nível, sem objeto aninhado.
@immutable
final class AdminChallenge {
  const new({
    required this.challenge,
    required this.actions,
    required this.runs,
    required this.deadlineEvents,
    this.tiebreak,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminChallenge.fromJson(JsonMap json) => AdminChallenge(
    challenge: Challenge.fromJson(json),
    actions: readEnumList(
      json,
      AdminChallengeJsonKeys.actions,
      values: ChallengeAction.values,
      jsonValueOf: (item) => item.jsonValue,
    ),
    runs: readObjectList(json, AdminChallengeJsonKeys.runs, AdminRaceRun.fromJson),
    deadlineEvents: readInt(json, AdminChallengeJsonKeys.deadlineEvents),
    tiebreak: switch (json[AdminChallengeJsonKeys.tiebreak]) {
      null => null,
      final value => TiebreakCriterion.fromJson(value),
    },
  );

  /// O que o site também mostra.
  final Challenge challenge;

  /// O que o painel pode fazer agora; vazio quando o desafio não está pendente.
  final List<ChallengeAction> actions;

  /// Números das duas duplas, quando a corrida foi lançada.
  final List<AdminRaceRun> runs;

  /// Eventos que já contam no prazo de 2 do desafiado (2.3).
  final int deadlineEvents;

  /// Critério que desempatou, quando os dois chegaram juntos (3.4).
  final TiebreakCriterion? tiebreak;

  /// JSON no formato da API: os campos de [challenge] mais os do painel.
  JsonMap toJson() => {
    ...challenge.toJson(),
    AdminChallengeJsonKeys.actions: [for (final action in actions) action.toJson()],
    AdminChallengeJsonKeys.runs: [for (final run in runs) run.toJson()],
    AdminChallengeJsonKeys.deadlineEvents: deadlineEvents,
    AdminChallengeJsonKeys.tiebreak: tiebreak?.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is AdminChallenge &&
      other.challenge == challenge &&
      listEquals(other.actions, actions) &&
      listEquals(other.runs, runs) &&
      other.deadlineEvents == deadlineEvents &&
      other.tiebreak == tiebreak;

  @override
  int get hashCode => Object.hash(
    challenge,
    Object.hashAll(actions),
    Object.hashAll(runs),
    deadlineEvents,
    tiebreak,
  );
}
