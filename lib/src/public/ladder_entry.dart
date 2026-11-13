import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/duo.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [LadderEntry].
abstract final class LadderEntryJsonKeys {
  static const position = 'position';
  static const duo = 'duo';
}

/// Posição de uma dupla na lista, do 1º ao 10º (1.3).
///
/// A API calcula a posição a partir dos movimentos da lista; ninguém edita esta tabela.
@immutable
final class LadderEntry {
  const new({required this.position, required this.duo});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory LadderEntry.fromJson(JsonMap json) => LadderEntry(
    position: readInt(json, LadderEntryJsonKeys.position),
    duo: Duo.fromJson(readMap(json, LadderEntryJsonKeys.duo)),
  );

  /// Posição, de 1 a 10.
  final int position;

  /// Dupla que ocupa a posição.
  final Duo duo;

  /// JSON no formato da API.
  JsonMap toJson() => {
    LadderEntryJsonKeys.position: position,
    LadderEntryJsonKeys.duo: duo.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is LadderEntry && other.position == position && other.duo == duo;

  @override
  int get hashCode => Object.hash(position, duo);
}
