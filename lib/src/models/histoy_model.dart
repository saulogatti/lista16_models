/// Objeto base para histórico do driver.
class HistoryModel {
  /// ID do histórico.
  final String id;

  /// ID do driver.
  final String driverId;

  /// ID do carro.
  final String carId;

  /// Data do histórico.
  final DateTime date;

  /// Horário do histórico.
  final DateTime time;

  /// Local do histórico.
  final String location;

  const new({
    required this.id,
    required this.driverId,
    required this.carId,
    required this.date,
    required this.time,
    required this.location,
  });
}
