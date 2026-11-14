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
      ref: v0.11.0
```

Mudou o contrato: nova versão no `pubspec.yaml`, entrada no `CHANGELOG.md` e tag `vX.Y.Z`.

## O que tem

| Pasta | Tipo | O que é |
|---|---|---|
| `public/` | `Driver` | piloto: nome, apelido opcional (`displayName` cai no nome), cidade, foto e logo do banner. **Sem contato** |
| `public/` | `Car` | carro: nome, fotos e a oficina (`Workshop`, opcional). Sem dados técnicos nem placa |
| `public/` | `Workshop` | oficina que prepara o carro: nome e Instagram opcional, sem o `@` |
| `public/` | `Duo` | dupla piloto + carro, que é quem ocupa a posição, e se o site mostra o histórico de desafios dela (`showsHistory`, 5.3) |
| `public/` | `RaceEvent` | evento da lista: data, pista e `EventStatus` (agendado, em andamento, encerrado ou cancelado) |
| `public/` | `SiteContent` | conteúdo das páginas fixas: `SiteTexts` (sobre e regulamento) e `SiteContacts` (WhatsApp, Instagram e e-mail da organização) |
| `public/` | `Sponsor` | patrocinador: nome, logo, link, texto de detalhes opcional e ordem de exibição |
| `public/` | `LadderEntry` | posição na lista (de 1 a 10) e a dupla |
| `public/` | `Challenge` | desafio lançado livre pela organização: duplas, evento, origem, situação, resultado da corrida e a reação de cada um |
| `public/` | `Movement` | mudança de posição na lista, com a causa e o motivo opcional; é a história da lista |
| `admin/` | `AdminDriver` | `Driver` mais telefone (obrigatório) e e-mail, só para o painel |
| `admin/` | `AdminDuo` | dupla com o `AdminDriver`, a marca do histórico e a posição na lista; `DuoInputJsonKeys` são as chaves do corpo com que o painel cria e edita a dupla, com o piloto e o carro juntos |
| `admin/` | `AdminRaceRun` | tempos da cronometragem de uma dupla numa corrida, todos opcionais |
| `admin/` | `AdminRace` | corrida de um desafio ou avulsa (por exemplo, da disputa de entrada): as duas duplas, o vencedor e o motivo marcados pela organização, uma observação e os tempos |
| `admin/` | `*InputJsonKeys` | chaves dos corpos que o painel manda: ordem da lista, saída, desafio e corrida (`ladder_inputs.dart`) |
| `admin/` | `Editor`, `EditorSession` | quem entra no painel (nome e usuário) e a sessão aberta no login: token de acesso, quando ele vence, token de renovação e o editor; `LoginInputJsonKeys`, `RefreshInputJsonKeys` e `PasswordChangeInputJsonKeys` são as chaves dos corpos |
| `admin/` | `AdminMovement` | `Movement` mais o editor que fez a mudança, só para o painel |
| `admin/` | `AdminPublication` | situação da publicação do site: fila (`PublicationQueue`), se há alteração não publicada, quando o site no ar foi gerado e a última tentativa (`PublicationAttempt`) |
| `enums/` | `EventStatus`, `ChallengeOrigin`, `ChallengeStatus`, `RaceOutcome`, `MovementCause` | situação do evento, origem e situação do desafio, motivo do resultado e causa do movimento |

`public/` é o que o site pode receber; `admin/` acrescenta o que só o painel vê. Carro, evento,
conteúdo e patrocinador não têm dado privado, então o painel usa os mesmos tipos de `public/`.

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

O sistema não aplica as regras da escada (pergunta 8.2 do `QUESTOES_LISTA16.md`, no
`site_lista16`): a organização edita a lista na mão, e desafio e corrida são só registro.
