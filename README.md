# lista16_models

Modelos compartilhados da **Lista 16** (piloto, carro, dupla, evento e enums), usados pela API
([backend_lista16](https://github.com/saulogatti/backend_lista16)), pelo painel
([admin_lista16](https://github.com/saulogatti/admin_lista16)) e pelo site
([site_lista16](https://github.com/saulogatti/site_lista16)).

Os projetos dependem deste pacote via git, travados numa tag de versão:

```yaml
dependencies:
  lista16_models:
    git:
      url: https://github.com/saulogatti/lista16_models.git
      ref: v0.6.0
```

Mudou o contrato: nova versão no `pubspec.yaml`, entrada no `CHANGELOG.md` e tag `vX.Y.Z`.

## O que tem

| Pasta | Tipo | O que é |
|---|---|---|
| `public/` | `Driver` | piloto: nome, apelido opcional (`displayName` cai no nome), cidade, foto e logo do banner. **Sem contato** |
| `public/` | `Car` | carro: nome, fotos e a oficina (`Workshop`, opcional). Sem dados técnicos nem placa |
| `public/` | `Workshop` | oficina que prepara o carro: nome e Instagram opcional, sem o `@` |
| `public/` | `Duo` | dupla piloto + carro, que é quem ocupa a posição |
| `public/` | `RaceEvent` | evento da lista: data, pista e `EventStatus` (agendado, em andamento, encerrado ou cancelado) |
| `public/` | `SiteContent` | conteúdo das páginas fixas: `SiteTexts` (sobre e regulamento) e `SiteContacts` (WhatsApp, Instagram e e-mail da organização) |
| `public/` | `Sponsor` | patrocinador: nome, logo, link, texto de detalhes opcional e ordem de exibição |
| `public/` | `LadderEntry` | posição na lista (de 1 a 10) e a dupla |
| `public/` | `Challenge` | desafio por posição ou de entrada: duplas, posição em jogo, evento, origem, situação, resultado e a reação de cada um |
| `public/` | `Movement` | mudança de posição na lista, com a causa e o motivo; é a história da lista |
| `public/` | `EntryQualifier` | disputa de entrada: candidatos, rodadas (`QualifierRound`), confrontos (`QualifierPairing`) e W.O. |
| `admin/` | `AdminDriver` | `Driver` mais telefone (obrigatório) e e-mail, só para o painel |
| `admin/` | `AdminRaceRun` | tempos da cronometragem e faltas de uma dupla numa corrida |
| `admin/` | `AdminChallenge` | `Challenge` mais os tempos, o critério de desempate, a conta do prazo e as ações liberadas (`ChallengeAction`) |
| `admin/` | `AdminLadder` | a lista com as ações liberadas para ela (`LadderAction`) e para cada dupla (`AdminLadderEntry`, `DuoAction`) |
| `admin/` | `AdminPublication` | situação da publicação do site: fila (`PublicationQueue`), se há alteração não publicada, quando o site no ar foi gerado e a última tentativa (`PublicationAttempt`) |
| `enums/` | `EventStatus`, `ChallengeKind`, `ChallengeOrigin`, `ChallengeStatus`, `RaceOutcome`, `MovementCause` | situação do evento, tipo, origem e situação do desafio, motivo do resultado e causa do movimento |

`public/` é o que o site pode receber; `admin/` acrescenta o que só o painel vê. Carro, dupla,
evento, conteúdo e patrocinador não têm dado privado, então o painel usa os mesmos tipos de
`public/`.

Cada modelo tem `fromJson` e `toJson`, e as chaves ficam em classes `*JsonKeys`
(`DriverJsonKeys.nickname`, por exemplo). `fromJson` lança `FormatException` quando falta campo
ou o tipo não bate. Os enums vão no JSON por um valor fixo (`jsonValue`), não pelo nome em Dart.
A data do evento vai como `AAAA-MM-DD`, sem hora. Instante (como o da publicação) vai em ISO 8601
com fuso e volta sempre em UTC.

```dart
final duo = Duo.fromJson(jsonDecode(body) as Map<String, Object?>);
print('${duo.driver.displayName} com ${duo.car.name}');
```

Mais em [`example/lista16_models_example.dart`](example/lista16_models_example.dart).

Ainda não tem Desafio, Corrida, Movimento da lista nem ranking: dependem de dúvidas abertas com
o dono (seção 5 do `ESTRUTURA_LISTA16.md`, no `site_lista16`).
