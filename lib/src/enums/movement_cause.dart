import 'package:lista16_models/src/core/json_read.dart';

/// Por que uma dupla mudou de posição na lista.
enum MovementCause {
  /// Desafio por posição ou de entrada decidido na corrida.
  challenge('challenge'),

  /// O desafiado deixou passar o prazo de 2 eventos sem correr (2.3).
  deadlineExpired('deadlineExpired'),

  /// Alguém não apareceu para correr o desafio (2.2 e 2.3).
  noShow('noShow'),

  /// A dupla saiu da lista (parou de correr, punição…), e quem estava abaixo subiu (4.1).
  left('left'),

  /// Mudou o carro ou o piloto da dupla: ela saiu da lista, e quem estava abaixo subiu (1.2).
  /// Os dados novos viram outra dupla, que começa fora da lista.
  duoChange('duoChange'),

  /// A dupla ficou parada e perdeu posição, ou saiu da lista no 10º (4.2).
  inactivity('inactivity'),

  /// Ajuste manual da organização, com motivo que aparece no site (4.3).
  manualAdjustment('manualAdjustment'),

  /// Carga da ordem da lista quando o sistema começou a ser usado (1.6).
  initialLoad('initialLoad');

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
