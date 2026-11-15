import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Photo].
abstract final class PhotoJsonKeys {
  static const id = 'id';
  static const sizes = 'sizes';
}

/// Campos do envio de foto do painel para a API (`multipart/form-data`). A resposta é a
/// [Photo] tratada.
abstract final class PhotoUploadFields {
  /// O arquivo da imagem.
  static const file = 'file';
}

/// Chaves JSON de [PhotoSize].
abstract final class PhotoSizeJsonKeys {
  static const width = 'width';
  static const height = 'height';
  static const path = 'path';
}

/// Foto já tratada pela API: enviada uma vez pelo painel e guardada em alguns tamanhos.
///
/// Quem mostra a foto escolhe o tamanho ([sizes], ou [atLeast]); o site monta o `srcset` com
/// todos. A foto não muda: outra imagem é outra [Photo], com outro [id].
@immutable
final class Photo {
  const new({required this.id, required this.sizes});

  /// Lê o JSON da API; lança [FormatException] se faltar campo, o tipo não bater ou não vier
  /// nenhum tamanho.
  factory Photo.fromJson(JsonMap json) {
    final sizes = <PhotoSize>[...readObjectList(json, PhotoJsonKeys.sizes, PhotoSize.fromJson)]
      ..sort((a, b) => a.width.compareTo(b.width));
    if (sizes.isEmpty) {
      throw const FormatException('Campo "sizes": a foto precisa de pelo menos um tamanho.');
    }
    return Photo(id: readString(json, PhotoJsonKeys.id), sizes: List.unmodifiable(sizes));
  }

  /// Identificador da foto, tirado do conteúdo dela.
  final String id;

  /// Os tamanhos da foto, do menor para o maior. Nunca vazia.
  final List<PhotoSize> sizes;

  /// O maior tamanho.
  PhotoSize get largest => sizes.last;

  /// O menor tamanho com pelo menos [width] pixels de largura, ou o maior se nenhum chega.
  PhotoSize atLeast(int width) =>
      sizes.firstWhere((size) => size.width >= width, orElse: () => largest);

  /// JSON no formato da API.
  JsonMap toJson() => {
    PhotoJsonKeys.id: id,
    PhotoJsonKeys.sizes: [for (final size in sizes) size.toJson()],
  };

  @override
  bool operator ==(Object other) =>
      other is Photo && other.id == id && listEquals(other.sizes, sizes);

  @override
  int get hashCode => Object.hash(id, Object.hashAll(sizes));
}

/// Um tamanho de [Photo]: as medidas em pixels e onde baixar.
@immutable
final class PhotoSize {
  const new({required this.width, required this.height, required this.path});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory PhotoSize.fromJson(JsonMap json) => PhotoSize(
    width: readInt(json, PhotoSizeJsonKeys.width),
    height: readInt(json, PhotoSizeJsonKeys.height),
    path: readString(json, PhotoSizeJsonKeys.path),
  );

  /// Largura em pixels.
  final int width;

  /// Altura em pixels.
  final int height;

  /// Caminho do arquivo, a partir do endereço da API (começa com `/`).
  final String path;

  /// JSON no formato da API.
  JsonMap toJson() => {
    PhotoSizeJsonKeys.width: width,
    PhotoSizeJsonKeys.height: height,
    PhotoSizeJsonKeys.path: path,
  };

  @override
  bool operator ==(Object other) =>
      other is PhotoSize && other.width == width && other.height == height && other.path == path;

  @override
  int get hashCode => Object.hash(width, height, path);
}
