import 'package:lista16_models/src/core/json_read.dart';

/// Por que uma dupla mudou de posição na lista.
///
/// Toda mudança é feita na mão pela organização: o sistema não aplica regra da escada (8.2).
enum MovementCause {
  /// A dupla saiu da lista (parou de correr, punição…), e quem estava abaixo subiu (4.1).
  left('left'),

  /// Mudou o carro ou o piloto da dupla: ela saiu da lista, e quem estava abaixo subiu (1.2).
  /// Os dados novos viram outra dupla, que começa fora da lista.
  duoChange('duoChange'),

  /// A organização editou a ordem: a dupla entrou, saiu ou mudou de posição (4.3, 8.2). Vale
  /// também para a primeira ordem da lista (1.6).
  manualAdjustment('manualAdjustment');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory MovementCause.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'MovementCause',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
