import 'package:lista16_models/src/core/json_read.dart';
import 'package:meta/meta.dart';

/// Em que pé está a fila de publicação do site.
enum PublicationQueue {
  /// Nada pedido nem rodando.
  idle('idle'),

  /// Alguém apertou "Publicar agora" e o servidor ainda não começou a gerar o site.
  requested('requested'),

  /// O site está sendo gerado agora.
  running('running');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory PublicationQueue.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'PublicationQueue',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}

/// Como terminou uma tentativa de publicar o site.
enum PublicationResult {
  /// O site novo entrou no ar.
  published('published'),

  /// O build falhou e o site antigo continuou no ar.
  failed('failed');

  new(this.jsonValue);

  /// Converte o valor JSON; lança [FormatException] se não for conhecido.
  factory PublicationResult.fromJson(Object? value) => enumFromJson(
    value,
    values: values,
    jsonValueOf: (item) => item.jsonValue,
    typeName: 'PublicationResult',
  );

  /// Valor estável no JSON. Não muda se o nome do item em Dart mudar.
  final String jsonValue;

  /// Valor JSON deste item.
  String toJson() => jsonValue;
}

/// Chaves JSON de [PublicationAttempt].
abstract final class PublicationAttemptJsonKeys {
  static const finishedAt = 'finishedAt';
  static const result = 'result';
  static const message = 'message';
}

/// A última tentativa de publicar o site, deu certo ou não.
@immutable
final class PublicationAttempt {
  const new({required this.finishedAt, required this.result, this.message});

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory PublicationAttempt.fromJson(JsonMap json) => PublicationAttempt(
    finishedAt: readDateTime(json, PublicationAttemptJsonKeys.finishedAt),
    result: PublicationResult.fromJson(json[PublicationAttemptJsonKeys.result]),
    message: readOptionalString(json, PublicationAttemptJsonKeys.message),
  );

  /// Quando terminou, em UTC.
  final DateTime finishedAt;

  /// Se o site novo entrou no ar.
  final PublicationResult result;

  /// Motivo da falha, como o servidor gravou (o fim do log do build). `null` quando deu certo.
  final String? message;

  /// JSON no formato da API.
  JsonMap toJson() => {
    PublicationAttemptJsonKeys.finishedAt: writeDateTime(finishedAt),
    PublicationAttemptJsonKeys.result: result.jsonValue,
    PublicationAttemptJsonKeys.message: message,
  };

  @override
  bool operator ==(Object other) =>
      other is PublicationAttempt &&
      other.finishedAt == finishedAt &&
      other.result == result &&
      other.message == message;

  @override
  int get hashCode => Object.hash(finishedAt, result, message);
}

/// Chaves JSON de [AdminPublication].
abstract final class AdminPublicationJsonKeys {
  static const queue = 'queue';
  static const hasUnpublishedChanges = 'hasUnpublishedChanges';
  static const lastPublishedAt = 'lastPublishedAt';
  static const lastAttempt = 'lastAttempt';
}

/// Situação da publicação do site, como o painel recebe.
///
/// O site estático é gerado de novo pelo botão "Publicar agora" ou pela publicação diária,
/// que só roda quando há alteração (seção 3 do `ESTRUTURA_LISTA16.md`). Quem decide o que é
/// alteração e quando gerar é o servidor; o painel só mostra.
@immutable
final class AdminPublication {
  const new({
    required this.queue,
    required this.hasUnpublishedChanges,
    this.lastPublishedAt,
    this.lastAttempt,
  });

  /// Lê o JSON da API; lança [FormatException] se faltar campo ou o tipo não bater.
  factory AdminPublication.fromJson(JsonMap json) {
    final attempt = readOptionalMap(json, AdminPublicationJsonKeys.lastAttempt);
    return AdminPublication(
      queue: PublicationQueue.fromJson(json[AdminPublicationJsonKeys.queue]),
      hasUnpublishedChanges: readBool(json, AdminPublicationJsonKeys.hasUnpublishedChanges),
      lastPublishedAt: readOptionalDateTime(json, AdminPublicationJsonKeys.lastPublishedAt),
      lastAttempt: attempt == null ? null : PublicationAttempt.fromJson(attempt),
    );
  }

  /// Se há pedido na fila ou build rodando.
  final PublicationQueue queue;

  /// Se o site no ar ainda não tem alguma alteração. A publicação diária só roda com isso.
  final bool hasUnpublishedChanges;

  /// Quando o site no ar foi gerado, em UTC. `null` se o servidor ainda não publicou nenhum.
  final DateTime? lastPublishedAt;

  /// A última tentativa, que pode ter falhado. `null` se nunca houve uma.
  final PublicationAttempt? lastAttempt;

  /// JSON no formato da API.
  JsonMap toJson() => {
    AdminPublicationJsonKeys.queue: queue.jsonValue,
    AdminPublicationJsonKeys.hasUnpublishedChanges: hasUnpublishedChanges,
    AdminPublicationJsonKeys.lastPublishedAt: lastPublishedAt == null
        ? null
        : writeDateTime(lastPublishedAt!),
    AdminPublicationJsonKeys.lastAttempt: lastAttempt?.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is AdminPublication &&
      other.queue == queue &&
      other.hasUnpublishedChanges == hasUnpublishedChanges &&
      other.lastPublishedAt == lastPublishedAt &&
      other.lastAttempt == lastAttempt;

  @override
  int get hashCode => Object.hash(queue, hasUnpublishedChanges, lastPublishedAt, lastAttempt);
}
