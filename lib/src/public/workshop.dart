import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Chaves JSON de [Workshop].
abstract final class WorkshopJsonKeys {
  static const name = 'name';
  static const instagram = 'instagram';
}

/// Oficina que prepara o carro (o preparador). Aparece no top 10 e na página da dupla.
///
/// É do carro, não do piloto: muda quando o carro vai para outra oficina.
@immutable
final class Workshop {
  const new({required this.name, this.instagram});

  /// Lê o JSON da API; lança [FormatException] se faltar o nome ou o tipo não bater.
  factory Workshop.fromJson(JsonMap json) => Workshop(
    name: readString(json, WorkshopJsonKeys.name),
    instagram: readOptionalString(json, WorkshopJsonKeys.instagram),
  );

  /// Nome da oficina.
  final String name;

  /// Usuário do Instagram da oficina, sem o `@`, ou `null` se não foi cadastrado.
  final String? instagram;

  /// JSON no formato da API. Sem Instagram vai como `null`.
  JsonMap toJson() => {WorkshopJsonKeys.name: name, WorkshopJsonKeys.instagram: instagram};

  @override
  bool operator ==(Object other) =>
      other is Workshop && other.name == name && other.instagram == instagram;

  @override
  int get hashCode => Object.hash(name, instagram);
}
