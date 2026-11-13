import 'dart:convert';

import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

/// Passa o JSON por texto, como chega pela rede.
Map<String, Object?> overTheWire(Map<String, Object?> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, Object?>;

Duo duoOf(int n) => Duo(
  id: 'duo-$n',
  driver: Driver(id: 'driver-$n', name: 'Piloto $n', city: 'Franca'),
  car: Car(id: 'car-$n', name: 'Carro $n'),
);

void main() {
  final challenge = Challenge(
    id: 'challenge-1',
    challenger: duoOf(5),
    challenged: duoOf(4),
    origin: ChallengeOrigin.scheduled,
    status: ChallengeStatus.closed,
    launchedOn: DateTime.utc(2026, 11, 2),
    eventId: 'event-1',
    closedOn: DateTime.utc(2026, 12, 6),
    outcome: RaceOutcome.falseStart,
    winnerId: 'duo-4',
    challengerReactionMs: -12,
    challengedReactionMs: 85,
  );

  group('LadderEntry', () {
    test('ida e volta no JSON', () {
      final entry = LadderEntry(position: 3, duo: duoOf(3));
      expect(LadderEntry.fromJson(overTheWire(entry.toJson())), entry);
    });
  });

  group('Challenge', () {
    test('ida e volta no JSON, com e sem resultado', () {
      expect(Challenge.fromJson(overTheWire(challenge.toJson())), challenge);
      final pending = Challenge(
        id: 'challenge-2',
        challenger: duoOf(11),
        challenged: duoOf(3),
        origin: ChallengeOrigin.atEvent,
        status: ChallengeStatus.pending,
        launchedOn: DateTime.utc(2026, 11, 12),
      );
      final json = overTheWire(pending.toJson());
      expect(json[ChallengeJsonKeys.outcome], isNull);
      expect(Challenge.fromJson(json), pending);
    });

    test('o modelo público não tem tempo de corrida, só a reação', () {
      final keys = challenge.toJson().keys;
      expect(keys, isNot(contains(AdminRaceJsonKeys.runs)));
      expect(keys.where((k) => k.endsWith('Ms')), [
        ChallengeJsonKeys.challengerReactionMs,
        ChallengeJsonKeys.challengedReactionMs,
      ]);
    });

    test('valor desconhecido lança FormatException', () {
      final json = overTheWire(challenge.toJson())..[ChallengeJsonKeys.status] = 'accepted';
      expect(() => Challenge.fromJson(json), throwsFormatException);
    });
  });

  group('Movement', () {
    test('ida e volta no JSON, com e sem motivo, entrada e saída da lista', () {
      final movements = [
        Movement(
          id: 'm1',
          sequence: 1,
          duo: duoOf(1),
          to: 1,
          cause: MovementCause.manualAdjustment,
          date: DateTime.utc(2026, 11, 12),
        ),
        Movement(
          id: 'm2',
          sequence: 2,
          duo: duoOf(8),
          from: 8,
          cause: MovementCause.left,
          reason: 'punição por conduta',
          date: DateTime.utc(2026, 11, 20),
        ),
        Movement(
          id: 'm3',
          sequence: 3,
          duo: duoOf(5),
          from: 5,
          to: 4,
          cause: MovementCause.manualAdjustment,
          reason: 'venceu o desafio',
          date: DateTime.utc(2026, 12, 6),
        ),
      ];
      for (final movement in movements) {
        expect(Movement.fromJson(overTheWire(movement.toJson())), movement);
      }
    });
  });

  group('admin', () {
    test('AdminRaceRun: ida e volta, com tempos opcionais', () {
      const full = AdminRaceRun(
        duoId: 'duo-4',
        reactionMs: 85,
        sixtyFeetMs: 1500,
        hundredMetersMs: 4500,
        elapsedMs: 7000,
        trapSpeedKmh: 181.5,
      );
      const onlyReaction = AdminRaceRun(duoId: 'duo-5', reactionMs: -12);
      expect(AdminRaceRun.fromJson(overTheWire(full.toJson())), full);
      expect(AdminRaceRun.fromJson(overTheWire(onlyReaction.toJson())), onlyReaction);
    });

    test('AdminRaceRun: velocidade inteira no JSON vira double', () {
      final json = overTheWire(const AdminRaceRun(duoId: 'd').toJson())
        ..[AdminRaceRunJsonKeys.trapSpeedKmh] = 180;
      expect(AdminRaceRun.fromJson(json).trapSpeedKmh, 180.0);
    });

    test('AdminRace: ida e volta, de um desafio e avulsa', () {
      final ofChallenge = AdminRace(
        id: 'race-1',
        challengeId: 'challenge-1',
        eventId: 'event-1',
        ranOn: DateTime.utc(2026, 12, 6),
        first: duoOf(5),
        second: duoOf(4),
        winnerId: 'duo-4',
        outcome: RaceOutcome.falseStart,
        runs: const [
          AdminRaceRun(duoId: 'duo-5', reactionMs: -12),
          AdminRaceRun(duoId: 'duo-4', reactionMs: 85, elapsedMs: 7000),
        ],
      );
      final loose = AdminRace(
        id: 'race-2',
        ranOn: DateTime.utc(2026, 12, 6),
        first: duoOf(11),
        second: duoOf(12),
        winnerId: 'duo-12',
        outcome: RaceOutcome.finishedBehind,
        note: 'Disputa de entrada, 1ª rodada',
        runs: const [],
      );
      for (final race in [ofChallenge, loose]) {
        expect(AdminRace.fromJson(overTheWire(race.toJson())), race);
      }
      expect(overTheWire(loose.toJson())[AdminRaceJsonKeys.challengeId], isNull);
    });
  });
}
