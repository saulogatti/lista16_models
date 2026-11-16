/// Tamanho máximo, em caracteres, dos textos livres que o painel manda.
///
/// O painel usa o número no próprio campo, com contador, para a pessoa ver o limite enquanto
/// digita; a API recusa o que passar dele. É tratamento de tela e de dado, não regra da lista
/// nem proteção: quem quiser saber o limite vê no contador do painel.
///
/// A conta é por caractere (ponto de código Unicode), depois de tirar os espaços das pontas.
/// Quebra de linha conta como um.
abstract final class TextLimits {
  /// Nome do piloto.
  static const driverName = 60;

  /// Apelido do piloto.
  static const driverNickname = 30;

  /// Cidade do piloto.
  static const driverCity = 60;

  /// E-mail (do piloto e da organização).
  static const email = 254;

  /// Nome do carro.
  static const carName = 60;

  /// Nome da oficina.
  static const workshopName = 60;

  /// Nome do patrocinador.
  static const sponsorName = 60;

  /// Detalhes do patrocinador.
  static const sponsorDescription = 500;

  /// Link do patrocinador.
  static const sponsorLink = 1000;

  /// Pista do evento.
  static const eventTrack = 80;

  /// Descrição do evento.
  static const eventDescription = 1000;

  /// Motivo de uma mudança na lista (nova ordem ou saída).
  static const ladderReason = 300;

  /// Observação da corrida.
  static const raceNote = 500;

  /// Textos das páginas fixas do site (sobre e regulamento).
  static const siteText = 10000;
}
