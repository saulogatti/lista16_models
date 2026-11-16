import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/enums/event_status.dart';
import 'package:lista16_models/src/limits/text_limits.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [RaceEvent].
abstract final class RaceEventJsonKeys {
  static const id = 'id';
  static const date = 'date';
  static const track = 'track';
  static const description = 'description';
  static const status = 'status';
}

/// Evento da lista: data, pista, descrição opcional e situação. Os desafios só valem nele (2.5).
@immutable
final class RaceEvent {
  const new({
    required this.id,
    required this.date,
    required this.track,
    required this.status,
    this.description,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  ///
  /// Sem `description` (ou com `null`), o evento fica sem descrição.
  factory RaceEvent.fromJson(JsonMap json) => RaceEvent(
    id: readString(json, RaceEventJsonKeys.id),
    date: readDate(json, RaceEventJsonKeys.date),
    track: readString(json, RaceEventJsonKeys.track),
    description: readOptionalString(json, RaceEventJsonKeys.description),
    status: EventStatus.fromJson(json[RaceEventJsonKeys.status]),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Dia do evento. Só a data de calendário conta: no JSON vai como `AAAA-MM-DD`, sem hora.
  final DateTime date;

  /// Nome da pista.
  final String track;

  /// Texto livre da organização para quem vai: como chegar, o que levar, horário. É público e
  /// vai para o site. Até [TextLimits.eventDescription] caracteres.
  final String? description;

  /// Situação do evento.
  final EventStatus status;

  /// JSON no formato da API. Sem descrição, a chave vai com `null`.
  JsonMap toJson() => {
    RaceEventJsonKeys.id: id,
    RaceEventJsonKeys.date: writeDate(date),
    RaceEventJsonKeys.track: track,
    RaceEventJsonKeys.description: description,
    RaceEventJsonKeys.status: status.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is RaceEvent &&
      other.id == id &&
      writeDate(other.date) == writeDate(date) &&
      other.track == track &&
      other.description == description &&
      other.status == status;

  @override
  int get hashCode => Object.hash(id, writeDate(date), track, description, status);
}
