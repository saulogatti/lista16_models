/// Objeto base para carros.
class CarModel {
  /// Marca do carro.
  final String brand;

  /// Modelo do carro.
  final String model;

  /// Ano do carro.
  final String year;

  /// Cor do carro.
  final String color;

  /// Placa do carro.
  final String plate;

  const new({
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.plate,
  });
}
