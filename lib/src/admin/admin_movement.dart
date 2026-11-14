import 'package:lista16_models/src/admin/editor_session.dart';
import 'package:lista16_models/src/core/json_read.dart';
import 'package:lista16_models/src/public/movement.dart';
import 'package:meta/meta.dart';

/// Chaves JSON que [AdminMovement] acrescenta às de [MovementJsonKeys].
abstract final class AdminMovementJsonKeys {
  static const editor = 'editor';
}

/// [Movement] mais quem fez a mudança, só para o painel.
///
/// O site recebe o [Movement] sem o editor. No JSON, o editor fica no mesmo nível dos campos do
/// movimento.
@immutable
final class AdminMovement {
  const new({required this.movement, this.editor});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminMovement.fromJson(JsonMap json) {
    final editor = readOptionalMap(json, AdminMovementJsonKeys.editor);
    return AdminMovement(
      movement: Movement.fromJson(json),
      editor: editor == null ? null : Editor.fromJson(editor),
    );
  }

  /// O movimento como o site o vê.
  final Movement movement;

  /// Quem fez a mudança; `null` nos movimentos de antes do login.
  final Editor? editor;

  /// JSON no formato da API.
  JsonMap toJson() => {...movement.toJson(), AdminMovementJsonKeys.editor: editor?.toJson()};

  @override
  bool operator ==(Object other) =>
      other is AdminMovement && other.movement == movement && other.editor == editor;

  @override
  int get hashCode => Object.hash(movement, editor);
}
