import 'package:lista16_models/src/admin/admin_enums.dart';
import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/ladder_entry.dart';
import 'package:meta/meta.dart';

/// Chaves JSON que [AdminLadderEntry] acrescenta às de [LadderEntryJsonKeys].
abstract final class AdminLadderEntryJsonKeys {
  static const actions = 'actions';
  static const owesDefense = 'owesDefense';
  static const challengeRefusal = 'challengeRefusal';
}

/// Posição da lista como o painel recebe: a pública ([entry]) e o que a API libera para a dupla.
///
/// No JSON os campos ficam no mesmo nível, sem objeto aninhado.
@immutable
final class AdminLadderEntry {
  const new({
    required this.entry,
    required this.actions,
    required this.owesDefense,
    this.challengeRefusal,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminLadderEntry.fromJson(JsonMap json) => AdminLadderEntry(
    entry: LadderEntry.fromJson(json),
    actions: readEnumList(
      json,
      AdminLadderEntryJsonKeys.actions,
      values: DuoAction.values,
      jsonValueOf: (item) => item.jsonValue,
    ),
    owesDefense: readBool(json, AdminLadderEntryJsonKeys.owesDefense),
    challengeRefusal: readOptionalString(json, AdminLadderEntryJsonKeys.challengeRefusal),
  );

  /// Posição e dupla, como o site mostra.
  final LadderEntry entry;

  /// O que o painel pode fazer com a dupla agora.
  final List<DuoAction> actions;

  /// Se a dupla desafiou e precisa defender antes de desafiar de novo (2.4).
  final bool owesDefense;

  /// Por que a dupla não pode desafiar a de cima agora, na mensagem do servidor; `null` quando
  /// pode ou quando é o 1º.
  final String? challengeRefusal;

  /// JSON no formato da API: os campos de [entry] mais os do painel.
  JsonMap toJson() => {
    ...entry.toJson(),
    AdminLadderEntryJsonKeys.actions: [for (final action in actions) action.toJson()],
    AdminLadderEntryJsonKeys.owesDefense: owesDefense,
    AdminLadderEntryJsonKeys.challengeRefusal: challengeRefusal,
  };

  @override
  bool operator ==(Object other) =>
      other is AdminLadderEntry &&
      other.entry == entry &&
      listEquals(other.actions, actions) &&
      other.owesDefense == owesDefense &&
      other.challengeRefusal == challengeRefusal;

  @override
  int get hashCode => Object.hash(entry, Object.hashAll(actions), owesDefense, challengeRefusal);
}

/// Chaves JSON de [AdminLadder].
abstract final class AdminLadderJsonKeys {
  static const entries = 'entries';
  static const actions = 'actions';
}

/// A lista como o painel recebe: as posições e o que a API libera para a lista inteira.
@immutable
final class AdminLadder {
  const new({required this.entries, required this.actions});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminLadder.fromJson(JsonMap json) => AdminLadder(
    entries: readObjectList(json, AdminLadderJsonKeys.entries, AdminLadderEntry.fromJson),
    actions: readEnumList(
      json,
      AdminLadderJsonKeys.actions,
      values: LadderAction.values,
      jsonValueOf: (item) => item.jsonValue,
    ),
  );

  /// Posições, do 1º ao último. Pode ter menos de 10 (1.3).
  final List<AdminLadderEntry> entries;

  /// O que o painel pode fazer com a lista agora.
  final List<LadderAction> actions;

  /// JSON no formato da API.
  JsonMap toJson() => {
    AdminLadderJsonKeys.entries: [for (final entry in entries) entry.toJson()],
    AdminLadderJsonKeys.actions: [for (final action in actions) action.toJson()],
  };

  @override
  bool operator ==(Object other) =>
      other is AdminLadder &&
      listEquals(other.entries, entries) &&
      listEquals(other.actions, actions);

  @override
  int get hashCode => Object.hash(Object.hashAll(entries), Object.hashAll(actions));
}
