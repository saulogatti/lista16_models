import 'dart:convert';

import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

void main() {
  const editor = Editor(
    id: '019a1b2c-0000-7000-8000-0000000000e1',
    name: 'Maria Teste',
    username: 'maria',
  );

  Map<String, Object?> roundTrip(Map<String, Object?> json) =>
      jsonDecode(jsonEncode(json)) as Map<String, Object?>;

  group('Editor', () {
    test('ida e volta no JSON', () {
      expect(Editor.fromJson(roundTrip(editor.toJson())), editor);
    });

    test('campo ausente ou de tipo errado lança FormatException', () {
      expect(
        () => Editor.fromJson(editor.toJson()..remove(EditorJsonKeys.username)),
        throwsFormatException,
      );
      expect(
        () => Editor.fromJson(editor.toJson()..[EditorJsonKeys.name] = 1),
        throwsFormatException,
      );
    });
  });

  group('EditorSession', () {
    final session = EditorSession(
      accessToken: 'access-de-exemplo',
      accessExpiresAt: DateTime.utc(2026, 11, 14, 12, 15),
      refreshToken: 'refresh-de-exemplo',
      editor: editor,
    );

    test('ida e volta no JSON, com o instante em UTC', () {
      final json = roundTrip(session.toJson());

      expect(json[EditorSessionJsonKeys.accessExpiresAt], '2026-11-14T12:15:00.000Z');
      expect(EditorSession.fromJson(json), session);
    });

    test('instante sem fuso ou editor ausente lançam FormatException', () {
      expect(
        () => EditorSession.fromJson(
          session.toJson()..[EditorSessionJsonKeys.accessExpiresAt] = '2026-11-14T12:15:00',
        ),
        throwsFormatException,
      );
      expect(
        () => EditorSession.fromJson(session.toJson()..remove(EditorSessionJsonKeys.editor)),
        throwsFormatException,
      );
    });
  });

  group('AdminMovement', () {
    final movement = Movement(
      id: '019a1b2c-0000-7000-8000-0000000000m1',
      sequence: 3,
      duo: const Duo(
        id: '019a1b2c-0000-7000-8000-000000000003',
        driver: Driver(
          id: '019a1b2c-0000-7000-8000-000000000001',
          name: 'João da Silva',
          city: 'Ribeirão Preto',
        ),
        car: Car(id: '019a1b2c-0000-7000-8000-000000000002', name: 'Opalão'),
      ),
      cause: MovementCause.manualAdjustment,
      date: DateTime.utc(2026, 11, 14),
      from: 4,
      to: 2,
      reason: 'Ganhou o desafio',
    );

    test('ida e volta no JSON, com o editor no mesmo nível do movimento', () {
      final admin = AdminMovement(movement: movement, editor: editor);
      final json = roundTrip(admin.toJson());

      expect(json.keys, unorderedEquals([...movement.toJson().keys, AdminMovementJsonKeys.editor]));
      expect(AdminMovement.fromJson(json), admin);
    });

    test('movimento de antes do login vem sem editor', () {
      final admin = AdminMovement(movement: movement);
      final json = roundTrip(admin.toJson());

      expect(json[AdminMovementJsonKeys.editor], isNull);
      expect(AdminMovement.fromJson(json), admin);
    });

    test('o Movement lido do JSON do painel descarta o editor', () {
      final json = AdminMovement(movement: movement, editor: editor).toJson();

      expect(Movement.fromJson(json).toJson().containsKey(AdminMovementJsonKeys.editor), isFalse);
    });
  });
}
