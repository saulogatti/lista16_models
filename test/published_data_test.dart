import 'dart:convert';

import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

/// Passa o JSON por texto, como chega pela rede.
Map<String, Object?> overTheWire(Map<String, Object?> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, Object?>;

void main() {
  const photo = Photo(
    id: 'aaaaaaaaaaaaaaaa',
    sizes: [PhotoSize(width: 640, height: 480, path: '/midia/aaaaaaaaaaaaaaaa-640.jpg')],
  );
  const first = Duo(
    id: '019a1b2c-0000-7000-8000-000000000010',
    driver: Driver(id: 'd1', name: 'Ana Teste', city: 'Franca', photo: photo),
    car: Car(id: 'c1', name: 'Fuscão', photos: [photo]),
    showsHistory: true,
  );
  const second = Duo(
    id: '019a1b2c-0000-7000-8000-000000000020',
    driver: Driver(id: 'd2', name: 'Beto Teste', nickname: 'Betão', city: 'Batatais'),
    car: Car(id: 'c2', name: 'Chevette'),
  );
  final event = RaceEvent(
    id: 'e1',
    date: DateTime.utc(2026, 12, 6),
    track: 'Pista de teste',
    status: EventStatus.scheduled,
    description: 'Portão abre às 8h.',
  );
  final pending = Challenge(
    id: 'ch1',
    challenger: second,
    challenged: first,
    origin: ChallengeOrigin.scheduled,
    status: ChallengeStatus.pending,
    launchedOn: DateTime.utc(2026, 11, 10),
    eventId: 'e1',
  );
  final decided = Challenge(
    id: 'ch2',
    challenger: second,
    challenged: first,
    origin: ChallengeOrigin.atEvent,
    status: ChallengeStatus.closed,
    launchedOn: DateTime.utc(2026, 10, 4),
    closedOn: DateTime.utc(2026, 10, 4),
    winnerId: first.id,
    challengerReactionMs: 412,
    challengedReactionMs: 388,
  );
  final data = PublishedData(
    publishedAt: DateTime.utc(2026, 11, 17, 7),
    mediaBaseUrl: 'https://api.example.com',
    duos: const [first, second],
    events: [event],
    content: const SiteContent(
      texts: SiteTexts(about: 'Sobre a lista.'),
      contacts: SiteContacts(whatsapp: '16999990000', instagram: 'lista_teste'),
    ),
    sponsors: const [Sponsor(id: 's1', name: 'Oficina Teste', logo: photo, position: 0)],
    ladder: const [
      LadderEntry(position: 1, duo: first),
      LadderEntry(position: 2, duo: second),
    ],
    challenges: [pending],
    history: [decided],
  );

  test('ida e volta no JSON', () {
    expect(PublishedData.fromJson(overTheWire(data.toJson())), data);
  });

  test('vazio vai e volta, com a versão do formato', () {
    final empty = PublishedData(
      publishedAt: DateTime.utc(2026, 11, 17),
      mediaBaseUrl: 'https://api.example.com',
    );
    final json = overTheWire(empty.toJson());

    expect(json[PublishedDataJsonKeys.formatVersion], PublishedData.currentFormatVersion);
    expect(PublishedData.fromJson(json), empty);
  });

  test('a data vai em UTC, com fuso', () {
    final json = data.toJson();

    expect(json[PublishedDataJsonKeys.publishedAt], '2026-11-17T07:00:00.000Z');
  });

  test('versão do formato diferente lança FormatException', () {
    final json = overTheWire(data.toJson())..[PublishedDataJsonKeys.formatVersion] = 2;

    expect(() => PublishedData.fromJson(json), throwsFormatException);
  });

  test('lista ausente lança FormatException', () {
    final json = overTheWire(data.toJson())..remove(PublishedDataJsonKeys.ladder);

    expect(() => PublishedData.fromJson(json), throwsFormatException);
  });

  test('não leva contato do piloto nem tempo de corrida', () {
    final json = overTheWire(data.toJson());
    final drivers = [
      for (final duo in json[PublishedDataJsonKeys.duos]! as List<Object?>)
        (duo! as Map<String, Object?>)[DuoJsonKeys.driver]! as Map<String, Object?>,
    ];
    // O e-mail da organização (SiteContacts) é público; o do piloto, não.
    final challengesText = jsonEncode([
      json[PublishedDataJsonKeys.challenges],
      json[PublishedDataJsonKeys.history],
    ]);

    for (final driver in drivers) {
      expect(driver.keys, isNot(contains(AdminDriverJsonKeys.phone)));
      expect(driver.keys, isNot(contains(AdminDriverJsonKeys.email)));
    }
    for (final timeKey in [
      AdminRaceRunJsonKeys.sixtyFeetMs,
      AdminRaceRunJsonKeys.hundredMetersMs,
      AdminRaceRunJsonKeys.elapsedMs,
      AdminRaceRunJsonKeys.trapSpeedKmh,
    ]) {
      expect(challengesText, isNot(contains('"$timeKey"')));
    }
  });
}
