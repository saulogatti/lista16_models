import 'package:lista16_models/src/core/json_read.dart';

/// Motivo do resultado de uma corrida: por que o vencedor venceu.
///
/// Quem escolhe o motivo é a organização, junto com o vencedor: o sistema não calcula o
/// resultado nem o desempate (8.2). O desafio é uma corrida só, sem baterias (3.1).
enum RaceOutcome {
  /// O perdedor chegou atrás nos 201 m.
  finishedBehind('finishedBehind'),

  /// O perdedor queimou a largada.
  falseStart('falseStart'),

  /// O perdedor invadiu a faixa do meio da pista.
  crossedCenterLine('crossedCenterLine'),

  /// O carro do perdedor quebrou e não completou os 201 m.
  didNotFinish('didNotFinish'),

  /// O perdedor não apareceu para correr.
  noShow('noShow');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory RaceOutcome.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'RaceOutcome',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
