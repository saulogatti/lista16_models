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
