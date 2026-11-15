import 'dart:convert';

import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

/// Passa o JSON por texto, como chega pela rede.
Map<String, Object?> overTheWire(Map<String, Object?> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, Object?>;

void main() {
  const photo = Photo(
    id: 'a1b2c3d4e5f60718',
    sizes: [
      PhotoSize(width: 320, height: 240, path: '/midia/a1b2c3d4e5f60718-320.jpg'),
      PhotoSize(width: 640, height: 480, path: '/midia/a1b2c3d4e5f60718-640.jpg'),
      PhotoSize(width: 1600, height: 1200, path: '/midia/a1b2c3d4e5f60718-1600.jpg'),
    ],
  );

  group('Photo', () {
    test('ida e volta no JSON', () {
      expect(Photo.fromJson(overTheWire(photo.toJson())), photo);
    });

    test('os tamanhos ficam do menor para o maior, em qualquer ordem que cheguem', () {
      final json = overTheWire(photo.toJson());
      json[PhotoJsonKeys.sizes] = (json[PhotoJsonKeys.sizes]! as List<Object?>).reversed.toList();
      expect(Photo.fromJson(json).sizes.map((size) => size.width), [320, 640, 1600]);
    });

    test('atLeast escolhe o menor que chega na largura, ou o maior', () {
      expect(photo.atLeast(300).width, 320);
      expect(photo.atLeast(321).width, 640);
      expect(photo.atLeast(640).width, 640);
      expect(photo.atLeast(4000).width, 1600);
      expect(photo.largest.width, 1600);
    });

    test('sem nenhum tamanho é recusada', () {
      expect(
        () => Photo.fromJson(const {PhotoJsonKeys.id: 'x', PhotoJsonKeys.sizes: <Object?>[]}),
        throwsFormatException,
      );
    });

    test('campo faltando ou de tipo errado é recusado', () {
      final noPath = overTheWire(photo.toJson());
      ((noPath[PhotoJsonKeys.sizes]! as List<Object?>).first! as Map<String, Object?>).remove(
        PhotoSizeJsonKeys.path,
      );
      expect(() => Photo.fromJson(noPath), throwsFormatException);

      final textWidth = overTheWire(photo.toJson());
      ((textWidth[PhotoJsonKeys.sizes]! as List<Object?>).first!
              as Map<String, Object?>)[PhotoSizeJsonKeys.width] =
          '320';
      expect(() => Photo.fromJson(textWidth), throwsFormatException);
    });
  });
}
