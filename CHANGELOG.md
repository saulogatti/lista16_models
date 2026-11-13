## 0.7.0

- `Car` ganha `showsHistory` (padrão `false`; ausente no JSON também vale `false`): a
  organização escolhe quais carros mostram no site o histórico de desafios (5.3). O
  histórico em si usa o `Challenge` que já existe, só com a reação na largada (3.6).

## 0.6.0

Desafio, Corrida, Disputa de entrada e Movimento da lista (etapa 4 do `ESTRUTURA_LISTA16.md`),
com as respostas do dono de 2026-11-12.

- `public/`, o que o site recebe (da corrida, só a reação na largada, 3.6):
  - `LadderEntry`: posição de 1 a 10 e a dupla. A lista pode ter menos de 10 (1.3).
  - `Challenge`: desafio por posição ou de entrada, posição em jogo, evento, se foi marcado
    antes ou feito no evento (`ChallengeOrigin`, 2.7), situação (`ChallengeStatus`), resultado
    e a reação de cada um.
  - `Movement`: mudança de posição com a causa (`MovementCause`), o motivo escrito pela
    organização, o desafio e o evento de origem e a ordem no registro.
  - `EntryQualifier`, `QualifierRound` e `QualifierPairing`: disputa de entrada com as rodadas
    sorteadas, o W.O. e o desafio que o vencedor lançou contra o 10º (2.2).
- `admin/`, só o painel:
  - `AdminRaceRun`: os tempos da cronometragem e as faltas (3.2 a 3.4).
  - `AdminChallenge`: o `Challenge` mais os tempos, o critério de desempate
    (`TiebreakCriterion`), os eventos que já contam no prazo e as ações que a API libera
    (`ChallengeAction`).
  - `AdminLadder` e `AdminLadderEntry`: a lista com as ações liberadas para a lista
    (`LadderAction`) e para cada dupla (`DuoAction`), se ela deve defesa (2.4) e por que não
    pode desafiar.
- `Car` ganha `workshop` (`Workshop`, opcional): a oficina que prepara o carro, com nome e
  Instagram opcional. Aparece no top 10 e na página da dupla (5.2).
- `RaceOutcome` ganha `didNotFinish` (quebrou antes dos 201 m, 3.3) e `noShow` (não apareceu,
  2.2 e 2.3). Os valores que já existiam não mudam.

## 0.5.0

Publicação do site (seção 3 do `ESTRUTURA_LISTA16.md`). Só acrescenta tipos.

- `AdminPublication`: a situação que o painel mostra. Fila (`PublicationQueue`: nada, pedido
  ou gerando), se há alteração ainda não publicada, quando o site no ar foi gerado e a última
  tentativa (`PublicationAttempt`, com o resultado e o motivo da falha).
- Instantes em ISO 8601 com fuso; o modelo devolve sempre em UTC.

## 0.4.0

Respostas do dono ao cadastro (2.5, 5.1 e 5.4). Quebra o contrato da 0.3.0.

- `Driver.nickname` passa a ser opcional (`String?`). O novo `displayName` devolve o apelido,
  ou o nome quando o piloto não tem apelido.
- `AdminDriver.phone` passa a ser obrigatório: todo piloto tem telefone com WhatsApp.
- `EventStatus.cancelled`: evento cancelado ou adiado, que fica marcado para todos saberem.
- `Sponsor.description`: texto opcional de detalhes do patrocinador.

## 0.3.0

Conteúdo das páginas fixas do site (resposta 5.4). Só acrescenta tipos: o que já existia não
muda.

- `SiteTexts`: textos de "Sobre" e "Regulamento", texto puro com parágrafos separados por linha
  em branco. Opcionais: `null` enquanto o dono não mandou.
- `SiteContacts`: WhatsApp (só dígitos, com DDD), Instagram (sem `@`) e e-mail da organização.
  Opcionais. Não é o contato do piloto.
- `SiteContent`: os dois juntos, como o site recebe.
- `Sponsor`: nome, logo, link opcional e a ordem de exibição (`position`).

O formato dos textos e dos contatos, o que é opcional e os campos do patrocinador são
provisórios: podem mudar quando o dono da lista responder.

## 0.2.0

Modelos refeitos a partir das respostas do dono (`QUESTOES_LISTA16.md`) e da seção 6, passo 1,
do `ESTRUTURA_LISTA16.md`. Quebra o contrato da 0.1.0.

- Removidos `AboutModel`, `CarModel`, `DriverModel` e `HistoryModel`: contradiziam a 5.1 e a 5.2.
- `public/`, o que o site recebe:
  - `Driver`: nome, apelido, cidade, foto e logo do banner opcionais. Sem contato.
  - `Car`: nome e fotos. Sem marca, modelo, ano nem placa.
  - `Duo`: piloto + carro, quem ocupa a posição (1.1).
  - `RaceEvent`: data (`AAAA-MM-DD`), pista e `EventStatus`.
- `admin/`, o que o painel recebe: `AdminDriver`, o `Driver` mais telefone e e-mail.
- Enums `EventStatus` (`scheduled`, `inProgress`, `finished`), `ChallengeKind` (`position`,
  `entry`) e `RaceOutcome` (`finishedBehind`, `falseStart`, `crossedCenterLine`, `tiebreak`,
  `coinToss`, `deadlineExpired`).
- Chaves JSON em classes `*JsonKeys`; `fromJson` lança `FormatException` em campo ausente ou
  de tipo errado.

## 0.1.0

- Estrutura inicial do pacote.
