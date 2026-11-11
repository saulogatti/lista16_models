/// Leitura de campos JSON com [FormatException] quando o campo falta ou tem o tipo errado.
///
/// Uso interno do pacote: não é exportado.
library;

/// Objeto JSON já decodificado.
typedef JsonMap = Map<String, Object?>;

/// Lê um texto obrigatório.
String readString(JsonMap json, String key) {
  final value = json[key];
  if (value is String) {
    return value;
  }
  throw _invalid(key, 'texto', value);
}

/// Lê um texto opcional: ausente ou `null` vira `null`.
String? readOptionalString(JsonMap json, String key) {
  final value = json[key];
  if (value == null || value is String) {
    return value as String?;
  }
  throw _invalid(key, 'texto ou null', value);
}

/// Lê uma lista de textos obrigatória (pode ser vazia).
List<String> readStringList(JsonMap json, String key) {
  final value = json[key];
  if (value is List<Object?> && value.every((item) => item is String)) {
    return List.unmodifiable(value.cast<String>());
  }
  throw _invalid(key, 'lista de textos', value);
}

/// Lê um objeto JSON obrigatório.
JsonMap readMap(JsonMap json, String key) {
  final value = json[key];
  if (value is Map<String, Object?>) {
    return value;
  }
  throw _invalid(key, 'objeto', value);
}

/// Lê uma data de calendário (`AAAA-MM-DD`), sem hora nem fuso.
///
/// Devolve um [DateTime] em UTC à meia-noite, para a data não mudar com o fuso de quem lê.
DateTime readDate(JsonMap json, String key) {
  final value = json[key];
  if (value is String && _datePattern.hasMatch(value)) {
    final date = DateTime.parse('${value}T00:00:00Z');
    if (writeDate(date) == value) {
      return date;
    }
  }
  throw _invalid(key, 'data AAAA-MM-DD', value);
}

/// Escreve a data de calendário de [date] como `AAAA-MM-DD`, ignorando hora e fuso.
String writeDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

/// Converte o valor JSON de um enum, comparando com o valor de cada item em [values].
T enumFromJson<T extends Enum>(
  Object? value, {
  required List<T> values,
  required String Function(T item) jsonValueOf,
  required String typeName,
}) {
  for (final item in values) {
    if (jsonValueOf(item) == value) {
      return item;
    }
  }
  throw FormatException('Valor desconhecido para $typeName: $value');
}

/// Lê um enum obrigatório pelo valor JSON de cada item.
T readEnum<T extends Enum>(
  JsonMap json,
  String key, {
  required List<T> values,
  required String Function(T item) jsonValueOf,
}) {
  final value = json[key];
  if (value is String) {
    return enumFromJson(value, values: values, jsonValueOf: jsonValueOf, typeName: key);
  }
  throw _invalid(key, 'texto', value);
}

/// Compara duas listas item a item.
bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

final _datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

FormatException _invalid(String key, String expected, Object? value) =>
    FormatException('Campo "$key": esperado $expected, veio ${value.runtimeType}');
