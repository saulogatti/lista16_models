import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [AdminRaceRun].
abstract final class AdminRaceRunJsonKeys {
  static const duoId = 'duoId';
  static const reactionMs = 'reactionMs';
  static const sixtyFeetMs = 'sixtyFeetMs';
  static const hundredMetersMs = 'hundredMetersMs';
  static const elapsedMs = 'elapsedMs';
  static const trapSpeedKmh = 'trapSpeedKmh';
  static const jumpedStart = 'jumpedStart';
  static const crossedCenterLine = 'crossedCenterLine';
  static const didNotFinish = 'didNotFinish';
}

/// Números de uma dupla numa corrida, como a cronometragem entrega e a organização confirma
/// (2.6, 3.2).
///
/// Só o painel vê: o tempo da corrida não aparece para ninguém (3.6). Os tempos são opcionais,
/// porque quem não precisou correr não tem (3.3). Tempos em milissegundos, sem a reação.
@immutable
final class AdminRaceRun {
  const new({
    required this.duoId,
    this.reactionMs,
    this.sixtyFeetMs,
    this.hundredMetersMs,
    this.elapsedMs,
    this.trapSpeedKmh,
    this.jumpedStart = false,
    this.crossedCenterLine = false,
    this.didNotFinish = false,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminRaceRun.fromJson(JsonMap json) => AdminRaceRun(
    duoId: readString(json, AdminRaceRunJsonKeys.duoId),
    reactionMs: readOptionalInt(json, AdminRaceRunJsonKeys.reactionMs),
    sixtyFeetMs: readOptionalInt(json, AdminRaceRunJsonKeys.sixtyFeetMs),
    hundredMetersMs: readOptionalInt(json, AdminRaceRunJsonKeys.hundredMetersMs),
    elapsedMs: readOptionalInt(json, AdminRaceRunJsonKeys.elapsedMs),
    trapSpeedKmh: readOptionalDouble(json, AdminRaceRunJsonKeys.trapSpeedKmh),
    jumpedStart: readBool(json, AdminRaceRunJsonKeys.jumpedStart),
    crossedCenterLine: readBool(json, AdminRaceRunJsonKeys.crossedCenterLine),
    didNotFinish: readBool(json, AdminRaceRunJsonKeys.didNotFinish),
  );

  /// Dupla que correu nesta raia.
  final String duoId;

  /// Reação na largada; negativa é queima (3.3). É o único número público.
  final int? reactionMs;

  /// Tempo nos 60 pés.
  final int? sixtyFeetMs;

  /// Tempo nos 100 m.
  final int? hundredMetersMs;

  /// Tempo nos 201 m.
  final int? elapsedMs;

  /// Velocidade final, em km/h.
  final double? trapSpeedKmh;

  /// Queimou a largada, marcado pela organização (3.3).
  final bool jumpedStart;

  /// Invadiu a faixa do meio (3.3).
  final bool crossedCenterLine;

  /// Quebrou e não completou os 201 m (3.3).
  final bool didNotFinish;

  /// JSON no formato da API.
  JsonMap toJson() => {
    AdminRaceRunJsonKeys.duoId: duoId,
    AdminRaceRunJsonKeys.reactionMs: reactionMs,
    AdminRaceRunJsonKeys.sixtyFeetMs: sixtyFeetMs,
    AdminRaceRunJsonKeys.hundredMetersMs: hundredMetersMs,
    AdminRaceRunJsonKeys.elapsedMs: elapsedMs,
    AdminRaceRunJsonKeys.trapSpeedKmh: trapSpeedKmh,
    AdminRaceRunJsonKeys.jumpedStart: jumpedStart,
    AdminRaceRunJsonKeys.crossedCenterLine: crossedCenterLine,
    AdminRaceRunJsonKeys.didNotFinish: didNotFinish,
  };

  @override
  bool operator ==(Object other) =>
      other is AdminRaceRun &&
      other.duoId == duoId &&
      other.reactionMs == reactionMs &&
      other.sixtyFeetMs == sixtyFeetMs &&
      other.hundredMetersMs == hundredMetersMs &&
      other.elapsedMs == elapsedMs &&
      other.trapSpeedKmh == trapSpeedKmh &&
      other.jumpedStart == jumpedStart &&
      other.crossedCenterLine == crossedCenterLine &&
      other.didNotFinish == didNotFinish;

  @override
  int get hashCode => Object.hash(
    duoId,
    reactionMs,
    sixtyFeetMs,
    hundredMetersMs,
    elapsedMs,
    trapSpeedKmh,
    jumpedStart,
    crossedCenterLine,
    didNotFinish,
  );
}
