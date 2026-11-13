/// Chaves dos corpos com que o painel edita a lista, os desafios e as corridas.
///
/// O servidor confere só os dados (dupla ativa, evento aberto, formato), não as regras da
/// escada (8.2).
library;

/// Corpo do `PUT /api/v1/admin/ladder/order`: a lista inteira, de cima para baixo (4.3, 8.2).
///
/// Põe dupla nova, tira dupla e reordena numa operação só; é também a primeira ordem da lista
/// (1.6). Cada dupla que entrou, saiu ou mudou de posição vira um movimento
/// `manualAdjustment`, com o mesmo [reason].
abstract final class LadderOrderInputJsonKeys {
  /// Ids das duplas, de cima para baixo; no máximo 10, sem repetir, todas ativas.
  static const duoIds = 'duoIds';

  /// Motivo opcional, que aparece no site.
  static const reason = 'reason';
}

/// Corpo do `POST /api/v1/admin/ladder/exits`: uma dupla sai da lista, e quem estava abaixo
/// sobe (4.1, 1.2).
abstract final class LadderExitInputJsonKeys {
  /// Id da dupla que sai.
  static const duoId = 'duoId';

  /// `left` ou `duoChange` (`MovementCause`).
  static const cause = 'cause';

  /// Motivo opcional, que aparece no site.
  static const reason = 'reason';
}

/// Corpo do `POST` e do `PUT` de `/api/v1/admin/challenges`: um desafio lançado livre (8.2).
///
/// Desafiante e desafiado são duas duplas ativas diferentes, dentro ou fora da lista. Com a
/// corrida lançada, as duplas não mudam mais.
abstract final class ChallengeInputJsonKeys {
  /// Id da dupla que desafia.
  static const challengerId = 'challengerId';

  /// Id da dupla desafiada.
  static const challengedId = 'challengedId';

  /// Evento em que o desafio deve ser corrido; opcional. Encerrado ou cancelado é recusado.
  static const eventId = 'eventId';

  /// `scheduled` ou `atEvent` (`ChallengeOrigin`).
  static const origin = 'origin';
}

/// Corpo do `POST` e do `PUT` de `/api/v1/admin/races`: a corrida lançada pela organização.
///
/// Com [challengeId], as duplas são as do desafio e [firstDuoId] e [secondDuoId] não vão; o
/// desafio passa a `closed`. Sem ele, a corrida é avulsa e as duas duplas são obrigatórias.
abstract final class RaceInputJsonKeys {
  /// Desafio desta corrida; só no `POST`. Ausente na corrida avulsa.
  static const challengeId = 'challengeId';

  /// Uma das duplas da corrida avulsa.
  static const firstDuoId = 'firstDuoId';

  /// A outra dupla da corrida avulsa.
  static const secondDuoId = 'secondDuoId';

  /// Evento da corrida; opcional. Na corrida de um desafio, ausente vale o evento do desafio.
  static const eventId = 'eventId';

  /// Dia da corrida (`AAAA-MM-DD`); ausente vale hoje, no horário de Brasília.
  static const ranOn = 'ranOn';

  /// Id da dupla que venceu; uma das duas da corrida.
  static const winnerId = 'winnerId';

  /// Motivo do resultado (`RaceOutcome`).
  static const outcome = 'outcome';

  /// Observação livre, opcional.
  static const note = 'note';

  /// Números de cada dupla (`AdminRaceRun`); opcional, no máximo um por dupla da corrida.
  static const runs = 'runs';
}
