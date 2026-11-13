import 'package:lista16_models/src/core/json_read.dart';

/// Critério que desempatou uma corrida em que os dois chegaram juntos (3.4).
///
/// Só o painel vê: o site mostra apenas que houve desempate, porque os tempos não aparecem
/// (3.6).
enum TiebreakCriterion {
  /// Menor reação na largada.
  reaction('reaction'),

  /// Menor tempo nos 60 pés.
  sixtyFeet('sixtyFeet'),

  /// Menor tempo nos 100 m.
  hundredMeters('hundredMeters'),

  /// Maior velocidade final.
  trapSpeed('trapSpeed');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory TiebreakCriterion.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'TiebreakCriterion',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}

/// O que o painel pode fazer com um desafio pendente agora. Quem decide é a API.
enum ChallengeAction {
  /// Lançar o resultado da corrida.
  recordRace('recordRace'),

  /// Dar o prazo de 2 eventos por vencido: o desafiado perde (2.3).
  expireDeadline('expireDeadline'),

  /// Registrar que alguém não apareceu para correr (2.2 e 2.3).
  recordNoShow('recordNoShow'),

  /// Cancelar o desafio sem resultado.
  cancel('cancel');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory ChallengeAction.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'ChallengeAction',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}

/// O que o painel pode fazer com uma dupla da lista agora. Quem decide é a API.
enum DuoAction {
  /// Desafiar a dupla logo acima (2.1).
  challenge('challenge'),

  /// Tirar a dupla da lista: saída (4.1) ou troca de carro (1.2).
  leave('leave');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory DuoAction.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'DuoAction',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}

/// O que o painel pode fazer com a lista inteira agora. Quem decide é a API.
enum LadderAction {
  /// Digitar a ordem da lista do zero, quando ela ainda não tem nenhum movimento (1.6).
  loadInitial('loadInitial'),

  /// Mudar a ordem na mão, com motivo (4.3).
  reorder('reorder'),

  /// Começar uma disputa de entrada (2.2).
  startQualifier('startQualifier');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory LadderAction.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'LadderAction',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}
