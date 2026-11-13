import 'package:lista16_models/src/core/json_read.dart';

/// Situação de um desafio.
///
/// O desafio é só registro: nenhuma situação muda a lista sozinha (8.2).
enum ChallengeStatus {
  /// Lançado e ainda sem corrida.
  pending('pending'),

  /// A corrida foi lançada, com o vencedor e o motivo (`RaceOutcome`). Apagar a corrida volta o
  /// desafio para [pending].
  closed('closed'),

  /// Cancelado pela organização sem corrida.
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
