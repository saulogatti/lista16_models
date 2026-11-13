import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/enums/movement_cause.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Movement].
abstract final class MovementJsonKeys {
  static const id = 'id';
  static const sequence = 'sequence';
  static const duo = 'duo';
  static const from = 'from';
  static const to = 'to';
  static const cause = 'cause';
  static const reason = 'reason';
  static const date = 'date';
}

/// Mudança de posição de uma dupla na lista, com a causa.
///
/// O registro de movimentos só recebe acréscimos, e o ranking sai dele. É também a história da
/// lista: "por que fulano caiu" (1.6, 4.3). Toda mudança é feita na mão (8.2).
@immutable
final class Movement {
  const new({
    required this.id,
    required this.sequence,
    required this.duo,
    required this.cause,
    required this.date,
    this.from,
    this.to,
    this.reason,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Movement.fromJson(JsonMap json) => Movement(
    id: readString(json, MovementJsonKeys.id),
    sequence: readInt(json, MovementJsonKeys.sequence),
    duo: Duo.fromJson(readMap(json, MovementJsonKeys.duo)),
    cause: MovementCause.fromJson(json[MovementJsonKeys.cause]),
    date: readDate(json, MovementJsonKeys.date),
    from: readOptionalInt(json, MovementJsonKeys.from),
    to: readOptionalInt(json, MovementJsonKeys.to),
    reason: readOptionalString(json, MovementJsonKeys.reason),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Ordem do movimento no registro: o maior é o mais recente.
  final int sequence;

  /// Dupla que mudou de posição.
  final Duo duo;

  /// Posição antes; `null` quando a dupla entrou na lista.
  final int? from;

  /// Posição depois; `null` quando a dupla saiu da lista.
  final int? to;

  /// Por que a dupla mudou de posição.
  final MovementCause cause;

  /// Motivo escrito pela organização, sempre opcional. Aparece no site (4.3).
  final String? reason;

  /// Dia do movimento.
  final DateTime date;

  /// JSON no formato da API.
  JsonMap toJson() => {
    MovementJsonKeys.id: id,
    MovementJsonKeys.sequence: sequence,
    MovementJsonKeys.duo: duo.toJson(),
    MovementJsonKeys.from: from,
    MovementJsonKeys.to: to,
    MovementJsonKeys.cause: cause.toJson(),
    MovementJsonKeys.reason: reason,
    MovementJsonKeys.date: writeDate(date),
  };

  @override
  bool operator ==(Object other) =>
      other is Movement &&
      other.id == id &&
      other.sequence == sequence &&
      other.duo == duo &&
      other.from == from &&
      other.to == to &&
      other.cause == cause &&
      other.reason == reason &&
      writeDate(other.date) == writeDate(date);

  @override
  int get hashCode => Object.hash(id, sequence, duo, from, to, cause, reason, writeDate(date));
}
