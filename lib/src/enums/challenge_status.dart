import 'package:lista16_models/src/core/json_read.dart';

/// Situação de um desafio.
///
/// Não existe aceitar nem recusar: o desafio nasce pendente (2.3).
enum ChallengeStatus {
  /// Lançado e ainda sem resultado. O desafiado tem 2 eventos para correr (2.3); no desafio de
  /// entrada, o 10º corre na hora (2.2).
  pending('pending'),

  /// Decidido: na corrida, por prazo vencido ou por falta. O motivo fica em `RaceOutcome`.
  closed('closed'),

  /// Cancelado pela organização sem resultado, por exemplo porque as posições mudaram antes da
  /// corrida.
  cancelled('cancelled');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory ChallengeStatus.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'ChallengeStatus',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
