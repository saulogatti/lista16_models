import 'package:lista16_models/src/core/json_read.dart';

/// Quando o desafio foi feito (2.7).
enum ChallengeOrigin {
  /// Marcado antes do evento e divulgado na agenda.
  scheduled('scheduled'),

  /// Feito no próprio evento, depois dos desafios marcados. Se os dois deixarem para depois,
  /// esse evento não conta no prazo de 2 eventos (2.3).
  atEvent('atEvent');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory ChallengeOrigin.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'ChallengeOrigin',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
