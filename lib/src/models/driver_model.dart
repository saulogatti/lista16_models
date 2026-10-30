/// Objeto base para pilotos.
class DriverModel {
  /// Nome do piloto.
  final String name;

  /// Email do piloto.
  final String email;

  /// Telefone do piloto.
  final String phone;

  /// Endereço do piloto.
  final String? address;

  /// Cidade do piloto.
  final String? city;

  /// Estado do piloto.
  final String? state;

  /// CEP do piloto.
  final String? zip;

  const new({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.state,
    this.zip,
  });
}
