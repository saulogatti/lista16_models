# AGENTS.md

Pacote Dart puro com os modelos compartilhados da Lista 16. Ele é usado pela API
(`backend_lista16`), pelo painel (`admin_lista16`) e pelo build do site (`site_lista16`). Como os
consumidores dependem dele e como versionar estão no `README.md`.

## Repositório público

Este repositório é **público** desde 2026-11-11, para o CI e o build Docker dos consumidores
baixarem o pacote sem token. Os outros três são privados. Qualquer um pode ler tudo o que entra
aqui: código, testes, exemplos, `CHANGELOG.md` e mensagens de commit. Por isso, nunca entra
aqui:

- segredo ou credencial: token (inclusive o de desenvolvimento do admin), senha, chave,
  `.env`, string de conexão;
- endereço interno: host da VPS, caminho no servidor, porta do banco;
- validação do backend ou detalhe de como ele se protege (autenticação, limites);
- dado real de piloto (nome, telefone, e-mail, foto) em teste ou exemplo. Use dado inventado.

Na dúvida, o lugar é o repositório privado que usa a informação.

## Domínio

- O ranking é uma **escada de desafio**, mas o sistema não aplica as regras dela (8.2): elas
  mudam muito, e a organização edita a lista na mão. Desafio e corrida são só registro. Quem
  ocupa a posição é a **dupla** piloto + carro.
- Antes de modelar, leia `QUESTOES_LISTA16.md` (respostas do dono da lista) e
  `ESTRUTURA_LISTA16.md` (proposta de estrutura) no repositório `site_lista16`, pasta local
  `~/repo/lista_16/site_lista16`. Modelo que depende de uma dúvida ainda aberta espera a resposta
  do dono.
- Este pacote tem só DTOs, enums e chaves JSON. Não modele regra da escada (quem pode desafiar,
  prazo, troca de posição, desempate, ações liberadas): nem aqui nem no backend (8.2).

## Público e painel

A estrutura proposta separa o que o site recebe do que o painel recebe:

- `lib/src/public/`: o que o site mostra. **Nunca** entra o contato do piloto (telefone, e-mail,
  endereço) nem o tempo de corrida (60 pés, 100 m, 201 m, velocidade final). Da corrida, só a
  reação na largada é pública.
- `lib/src/admin/`: o que o painel recebe, inclusive os dados privados. Só ganha tipo próprio
  o que tem dado privado (`AdminDriver`, `AdminRaceRun`, `AdminRace`) ou que só o painel
  recebe (`AdminPublication`); no resto o painel usa o tipo de `public/`. As chaves dos corpos
  que o painel manda ficam em `*InputJsonKeys` (`admin_duo.dart`, `ladder_inputs.dart`).
- `lib/src/enums/`: enums do domínio. Só entra enum com os valores já decididos pelo dono.
- `lib/src/core/`: leitura de JSON, interno. Não é exportado.

Desafio, Corrida e Movimento entraram na 0.6.0. Na 0.10.0 viraram registro livre (8.2), e a
Disputa de entrada saiu: os confrontos dela são corridas avulsas (`AdminRace` sem desafio).

## Serialização

`fromJson`/`toJson` **à mão**, sem `json_serializable` nem `build_runner`. São poucos modelos,
os consumidores dependem do pacote por git e não rodam gerador, e as chaves já ficam em classes
`*JsonKeys`. Para ler campo, use as funções de `lib/src/core/json_read.dart`: elas lançam
`FormatException` em campo ausente ou de tipo errado. Enum vai no JSON pelo `jsonValue` fixo de
cada item, nunca por `.name`. Modelo é `@immutable`, com `==` e `hashCode`.

## Regras de código

- Código em inglês; documentação `///` em português.
- Chaves JSON em classes (como `HealthJsonKeys` no backend), nunca strings soltas.
- Sem dependência de Flutter nem de pacote de servidor: o pacote tem de rodar nos três lados.
- Arquivo gerado (`*.g.dart`) não se edita à mão.

## Versão

Mudou o contrato: nova versão no `pubspec.yaml`, entrada no `CHANGELOG.md` e tag `vX.Y.Z`. Nos
consumidores, suba o `ref:` da dependência, rode `dart pub get` (ou `flutter pub get`) e ponha o
`pubspec.lock` no mesmo commit.

## Formatação

Nunca `dart format .`: formate só `lib test example` ou os arquivos alterados. Um hook em
`.claude/settings.json` bloqueia a forma proibida e formata cada `.dart` editado.

## Antes do pull request

```bash
dart analyze
dart format --output=none --set-exit-if-changed lib test example
dart test
```

## Git

- A branch base é a `main`.
- Mensagem de commit: `tipo: resumo em português` (ex.: `feat: modelos de piloto e carro`).
