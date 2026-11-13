import 'package:lista16_models/src/core/json_read.dart';

/// Motivo do resultado de uma corrida: por que o vencedor venceu.
///
/// O desafio é uma corrida só, sem baterias (3.1). Não existe empate (3.4). Os motivos de pista
/// (de [finishedBehind] a [coinToss]) valem para o desafio por posição e para a disputa de
/// entrada (2.2, 3.2, 3.3).
enum RaceOutcome {
  /// O perdedor chegou atrás nos 201 m (3.2).
  finishedBehind('finishedBehind'),

  /// O perdedor queimou a largada (3.3).
  falseStart('falseStart'),

  /// O perdedor invadiu a faixa do meio da pista (3.3).
  crossedCenterLine('crossedCenterLine'),

  /// Chegaram juntos e o desempate foi pelos tempos que a cronometragem tem e o site não mostra,
  /// nesta ordem: reação, 60 pés, 100 m, velocidade final (3.4). Qual critério decidiu só o
  /// painel vê (`TiebreakCriterion`).
  tiebreak('tiebreak'),

  /// Chegaram juntos e todos os tempos do desempate deram iguais: cara ou coroa (3.4).
  coinToss('coinToss'),

  /// Passaram os 2 eventos de prazo sem a corrida: o desafiado perde a posição para o desafiante
  /// (2.3). Não vale contra o vencedor da disputa de entrada: ali o 10º corre na hora (2.2).
  deadlineExpired('deadlineExpired'),

  /// O carro do perdedor quebrou e não completou os 201 m (3.3).
  didNotFinish('didNotFinish'),

  /// O perdedor não apareceu para correr (2.2 e 2.3).
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
