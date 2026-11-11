import 'package:lista16_models/src/core/json_read.dart';

/// Tipo de desafio.
enum ChallengeKind {
  /// Desafio por posição: a dupla desafia só a posição logo acima (2.1). Se ganhar, as duas
  /// trocam de posição.
  position('position'),

  /// Desafio de entrada: quem está fora desafia o 10º. Quem ganhar fica com a 10ª posição; se o
  /// 10º perder, sai da lista (2.2).
  entry('entry');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory ChallengeKind.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'ChallengeKind',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
