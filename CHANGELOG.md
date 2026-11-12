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
