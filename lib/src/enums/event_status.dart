import 'package:lista16_models/src/core/json_read.dart';

/// Situação de um evento da lista: agendado → em andamento → encerrado, ou cancelado.
///
/// Só no evento da lista o desafio vale, e nunca há dois eventos no mesmo mês (2.5).
enum EventStatus {
  /// Marcado, ainda não começou. Aparece na agenda do site (2.7).
  scheduled('scheduled'),

  /// Acontecendo. Os desafios podem acontecer até ele terminar (2.4).
  inProgress('inProgress'),

  /// Terminou. Fica sempre na história e não reabre (2.5).
  finished('finished'),

  /// Cancelado ou adiado. Fica marcado para todos saberem e não conta no prazo do desafio (2.5).
  cancelled('cancelled');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory EventStatus.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'EventStatus',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
