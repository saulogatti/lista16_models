import 'package:lista16_models/src/admin/admin_race_run.dart';
import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/enums/race_outcome.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [AdminRace].
abstract final class AdminRaceJsonKeys {
  static const id = 'id';
  static const challengeId = 'challengeId';
  static const eventId = 'eventId';
  static const ranOn = 'ranOn';
  static const first = 'first';
  static const second = 'second';
  static const winnerId = 'winnerId';
  static const outcome = 'outcome';
  static const note = 'note';
  static const runs = 'runs';
}

/// Corrida entre duas duplas, como o painel recebe: de um desafio ou avulsa (por exemplo, um
/// confronto da disputa de entrada, 1.3).
///
/// É só registro: a organização marca o vencedor e o motivo, e a lista não muda pelo
/// resultado (8.2). Os tempos ficam em [runs] e só o painel vê (3.6).
@immutable
final class AdminRace {
  const new({
    required this.id,
    required this.ranOn,
    required this.first,
    required this.second,
    required this.winnerId,
    required this.outcome,
    required this.runs,
    this.challengeId,
    this.eventId,
    this.note,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminRace.fromJson(JsonMap json) => AdminRace(
    id: readString(json, AdminRaceJsonKeys.id),
    ranOn: readDate(json, AdminRaceJsonKeys.ranOn),
    first: Duo.fromJson(readMap(json, AdminRaceJsonKeys.first)),
    second: Duo.fromJson(readMap(json, AdminRaceJsonKeys.second)),
    winnerId: readString(json, AdminRaceJsonKeys.winnerId),
    outcome: RaceOutcome.fromJson(json[AdminRaceJsonKeys.outcome]),
    runs: readObjectList(json, AdminRaceJsonKeys.runs, AdminRaceRun.fromJson),
    challengeId: readOptionalString(json, AdminRaceJsonKeys.challengeId),
    eventId: readOptionalString(json, AdminRaceJsonKeys.eventId),
    note: readOptionalString(json, AdminRaceJsonKeys.note),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Desafio desta corrida; `null` na corrida avulsa. Um desafio tem no máximo uma corrida
  /// (3.1).
  final String? challengeId;

  /// Evento em que a corrida aconteceu, quando houve.
  final String? eventId;

  /// Dia da corrida.
  final DateTime ranOn;

  /// Uma das duplas. Na corrida de um desafio, é o desafiante.
  final Duo first;

  /// A outra dupla. Na corrida de um desafio, é o desafiado.
  final Duo second;

  /// Id da dupla que venceu, [first] ou [second], marcada pela organização.
  final String winnerId;

  /// Por que o vencedor venceu, marcado pela organização.
  final RaceOutcome outcome;

  /// Observação livre da organização, por exemplo "Disputa de entrada, 1ª rodada".
  final String? note;

  /// Números de cada dupla que a organização lançou; zero, um ou dois.
  final List<AdminRaceRun> runs;

  /// JSON no formato da API.
  JsonMap toJson() => {
    AdminRaceJsonKeys.id: id,
    AdminRaceJsonKeys.challengeId: challengeId,
    AdminRaceJsonKeys.eventId: eventId,
    AdminRaceJsonKeys.ranOn: writeDate(ranOn),
    AdminRaceJsonKeys.first: first.toJson(),
    AdminRaceJsonKeys.second: second.toJson(),
    AdminRaceJsonKeys.winnerId: winnerId,
    AdminRaceJsonKeys.outcome: outcome.toJson(),
    AdminRaceJsonKeys.note: note,
    AdminRaceJsonKeys.runs: [for (final run in runs) run.toJson()],
  };

  @override
  bool operator ==(Object other) =>
      other is AdminRace &&
      other.id == id &&
      other.challengeId == challengeId &&
      other.eventId == eventId &&
      writeDate(other.ranOn) == writeDate(ranOn) &&
      other.first == first &&
      other.second == second &&
      other.winnerId == winnerId &&
      other.outcome == outcome &&
      other.note == note &&
      listEquals(other.runs, runs);

  @override
  int get hashCode => Object.hash(
    id,
    challengeId,
    eventId,
    writeDate(ranOn),
    first,
    second,
    winnerId,
    outcome,
    note,
    Object.hashAll(runs),
  );
}
