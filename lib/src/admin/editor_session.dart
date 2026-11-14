import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Editor].
abstract final class EditorJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const username = 'username';
}

/// Quem entra no painel e edita a lista (6.1).
///
/// Por enquanto todo editor pode tudo: as permissões esperam a resposta do dono.
@immutable
final class Editor {
  const new({required this.id, required this.name, required this.username});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory Editor.fromJson(JsonMap json) => Editor(
    id: readString(json, EditorJsonKeys.id),
    name: readString(json, EditorJsonKeys.name),
    username: readString(json, EditorJsonKeys.username),
  );

  /// Identificador (UUID v7 gerado pela API).
  final String id;

  /// Nome que o painel mostra.
  final String name;

  /// Usuário com que a pessoa entra no painel.
  final String username;

  /// JSON no formato da API.
  JsonMap toJson() => {
    EditorJsonKeys.id: id,
    EditorJsonKeys.name: name,
    EditorJsonKeys.username: username,
  };

  @override
  bool operator ==(Object other) =>
      other is Editor && other.id == id && other.name == name && other.username == username;

  @override
  int get hashCode => Object.hash(id, name, username);
}

/// Chaves JSON de [EditorSession].
abstract final class EditorSessionJsonKeys {
  static const accessToken = 'accessToken';
  static const accessExpiresAt = 'accessExpiresAt';
  static const refreshToken = 'refreshToken';
  static const editor = 'editor';
}

/// Sessão aberta no login ou renovada: os dois tokens e quem entrou.
///
/// O painel manda o [accessToken] em cada pedido e, quando ele vence, troca o [refreshToken]
/// por uma sessão nova.
@immutable
final class EditorSession {
  const new({
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshToken,
    required this.editor,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory EditorSession.fromJson(JsonMap json) => EditorSession(
    accessToken: readString(json, EditorSessionJsonKeys.accessToken),
    accessExpiresAt: readDateTime(json, EditorSessionJsonKeys.accessExpiresAt),
    refreshToken: readString(json, EditorSessionJsonKeys.refreshToken),
    editor: Editor.fromJson(readMap(json, EditorSessionJsonKeys.editor)),
  );

  /// Token dos pedidos (`Authorization: Bearer`).
  final String accessToken;

  /// Quando o [accessToken] vence, em UTC.
  final DateTime accessExpiresAt;

  /// Token que renova a sessão. Cada renovação devolve um novo.
  final String refreshToken;

  /// Quem entrou.
  final Editor editor;

  /// JSON no formato da API.
  JsonMap toJson() => {
    EditorSessionJsonKeys.accessToken: accessToken,
    EditorSessionJsonKeys.accessExpiresAt: writeDateTime(accessExpiresAt),
    EditorSessionJsonKeys.refreshToken: refreshToken,
    EditorSessionJsonKeys.editor: editor.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is EditorSession &&
      other.accessToken == accessToken &&
      other.accessExpiresAt.isAtSameMomentAs(accessExpiresAt) &&
      other.refreshToken == refreshToken &&
      other.editor == editor;

  @override
  int get hashCode => Object.hash(accessToken, accessExpiresAt.toUtc(), refreshToken, editor);
}

/// Chaves do corpo do login.
abstract final class LoginInputJsonKeys {
  static const username = 'username';
  static const password = 'password';
}

/// Chaves do corpo da renovação e da saída.
abstract final class RefreshInputJsonKeys {
  static const refreshToken = 'refreshToken';
}

/// Chaves do corpo da troca da própria senha.
abstract final class PasswordChangeInputJsonKeys {
  static const currentPassword = 'currentPassword';
  static const newPassword = 'newPassword';
}
