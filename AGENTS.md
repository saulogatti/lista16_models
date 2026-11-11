# AGENTS.md

Pacote Dart puro com os modelos compartilhados da Lista 16. Ele é usado pela API
(`backend_lista16`), pelo painel (`admin_lista16`) e pelo build do site (`site_lista16`). Como os
consumidores dependem dele e como versionar estão no `README.md`.

## Domínio

- O ranking é uma **escada de desafio**: o de baixo desafia o de cima e, se ganhar, os dois
  trocam de posição. Quem ocupa a posição é a **dupla** piloto + carro.
- Antes de modelar, leia `QUESTOES_LISTA16.md` (respostas do dono da lista) e
  `ESTRUTURA_LISTA16.md` (proposta de estrutura) no repositório `site_lista16`, pasta local
  `~/repo/lista_16/site_lista16`. Modelo que depende de uma dúvida ainda aberta espera a resposta
  do dono.
- Este pacote tem só DTOs, enums e chaves JSON. Regra de negócio (quem pode desafiar, prazo,
  troca de posição) fica no backend, não aqui.

## Público e painel

A estrutura proposta separa o que o site recebe do que o painel recebe:

- `lib/src/public/`: o que o site mostra. **Nunca** entra o contato do piloto (telefone, e-mail,
  endereço) nem o tempo de corrida (60 pés, 100 m, 201 m, velocidade final). Da corrida, só a
  reação na largada é pública.
- `lib/src/admin/`: o que o painel recebe, inclusive os dados privados.

Os modelos de `lib/src/models/` vieram antes das respostas do dono e vão ser refeitos (seção 4
do `ESTRUTURA_LISTA16.md`). Não amplie esses modelos.

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
