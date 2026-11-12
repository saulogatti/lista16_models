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
      ref: v0.3.0
```

Mudou o contrato: nova versão no `pubspec.yaml`, entrada no `CHANGELOG.md` e tag `vX.Y.Z`.

## O que tem

| Pasta | Tipo | O que é |
|---|---|---|
| `public/` | `Driver` | piloto: nome, apelido, cidade, foto e logo do banner. **Sem contato** |
| `public/` | `Car` | carro: nome e fotos. Sem dados técnicos nem placa |
| `public/` | `Duo` | dupla piloto + carro, que é quem ocupa a posição |
| `public/` | `RaceEvent` | evento da lista: data, pista e `EventStatus` |
| `public/` | `SiteContent` | conteúdo das páginas fixas: `SiteTexts` (sobre e regulamento) e `SiteContacts` (WhatsApp, Instagram e e-mail da organização) |
| `public/` | `Sponsor` | patrocinador: nome, logo, link e ordem de exibição |
| `admin/` | `AdminDriver` | `Driver` mais telefone e e-mail, só para o painel |
| `enums/` | `EventStatus`, `ChallengeKind`, `RaceOutcome` | situação do evento, tipo de desafio e motivo do resultado da corrida |

`public/` é o que o site pode receber; `admin/` acrescenta o que só o painel vê. Carro, dupla,
evento, conteúdo e patrocinador não têm dado privado, então o painel usa os mesmos tipos de
`public/`.

Cada modelo tem `fromJson` e `toJson`, e as chaves ficam em classes `*JsonKeys`
(`DriverJsonKeys.nickname`, por exemplo). `fromJson` lança `FormatException` quando falta campo
ou o tipo não bate. Os enums vão no JSON por um valor fixo (`jsonValue`), não pelo nome em Dart.
A data do evento vai como `AAAA-MM-DD`, sem hora.

```dart
final duo = Duo.fromJson(jsonDecode(body) as Map<String, Object?>);
print('${duo.driver.nickname} com ${duo.car.name}');
```

Mais em [`example/lista16_models_example.dart`](example/lista16_models_example.dart).

Ainda não tem Desafio, Corrida, Movimento da lista nem ranking: dependem de dúvidas abertas com
o dono (seção 5 do `ESTRUTURA_LISTA16.md`, no `site_lista16`).
