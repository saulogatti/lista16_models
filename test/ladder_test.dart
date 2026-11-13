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
    kind: ChallengeKind.position,
    challenger: duoOf(5),
    challenged: duoOf(4),
    position: 4,
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
        kind: ChallengeKind.entry,
        challenger: duoOf(11),
        challenged: duoOf(10),
        position: 10,
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
      expect(keys, isNot(contains(AdminChallengeJsonKeys.runs)));
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
    test('ida e volta no JSON, inclusive entrada e saída da lista', () {
      final movements = [
        Movement(
          id: 'm1',
          sequence: 1,
          duo: duoOf(1),
          to: 1,
          cause: MovementCause.initialLoad,
          date: DateTime.utc(2026, 11, 12),
        ),
        Movement(
          id: 'm2',
          sequence: 2,
          duo: duoOf(8),
          from: 8,
          cause: MovementCause.manualAdjustment,
          reason: 'punição por conduta',
          eventId: 'event-1',
          date: DateTime.utc(2026, 11, 20),
        ),
        Movement(
          id: 'm3',
          sequence: 3,
          duo: duoOf(5),
          from: 5,
          to: 4,
          cause: MovementCause.challenge,
          challengeId: 'challenge-1',
          date: DateTime.utc(2026, 12, 6),
        ),
      ];
      for (final movement in movements) {
        expect(Movement.fromJson(overTheWire(movement.toJson())), movement);
      }
    });
  });

  group('EntryQualifier', () {
    test('ida e volta no JSON com rodadas, W.O. e desafio lançado', () {
      final qualifier = EntryQualifier(
        id: 'q1',
        eventId: 'event-1',
        candidates: [duoOf(11), duoOf(12), duoOf(13)],
        rounds: [
          QualifierRound(
            number: 1,
            pairings: [
              QualifierPairing(
                id: 'p1',
                first: duoOf(11),
                second: duoOf(12),
                winnerId: 'duo-11',
                outcome: RaceOutcome.finishedBehind,
                firstReactionMs: 90,
                secondReactionMs: 110,
              ),
            ],
            bye: duoOf(13),
          ),
          QualifierRound(
            number: 2,
            pairings: [QualifierPairing(id: 'p2', first: duoOf(13), second: duoOf(11))],
          ),
        ],
      );
      expect(EntryQualifier.fromJson(overTheWire(qualifier.toJson())), qualifier);
      expect(qualifier.isFinished, isFalse);
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
      const fouled = AdminRaceRun(duoId: 'duo-5', reactionMs: -12, jumpedStart: true);
      expect(AdminRaceRun.fromJson(overTheWire(full.toJson())), full);
      expect(AdminRaceRun.fromJson(overTheWire(fouled.toJson())), fouled);
    });

    test('AdminRaceRun: velocidade inteira no JSON vira double', () {
      final json = overTheWire(const AdminRaceRun(duoId: 'd').toJson())
        ..[AdminRaceRunJsonKeys.trapSpeedKmh] = 180;
      expect(AdminRaceRun.fromJson(json).trapSpeedKmh, 180.0);
    });

    test('AdminChallenge: campos públicos e do painel no mesmo nível', () {
      final admin = AdminChallenge(
        challenge: challenge,
        actions: const [],
        runs: const [AdminRaceRun(duoId: 'duo-5', reactionMs: -12, jumpedStart: true)],
        deadlineEvents: 1,
        tiebreak: TiebreakCriterion.reaction,
      );
      final json = overTheWire(admin.toJson());
      expect(json[ChallengeJsonKeys.id], 'challenge-1');
      expect(AdminChallenge.fromJson(json), admin);
    });

    test('AdminLadder: ida e volta com ações', () {
      final ladder = AdminLadder(
        entries: [
          AdminLadderEntry(
            entry: LadderEntry(position: 1, duo: duoOf(1)),
            actions: const [DuoAction.leave],
            owesDefense: false,
          ),
          AdminLadderEntry(
            entry: LadderEntry(position: 2, duo: duoOf(2)),
            actions: const [DuoAction.challenge, DuoAction.leave],
            owesDefense: true,
            challengeRefusal: 'Quem desafiou precisa defender a posição antes.',
          ),
        ],
        actions: const [LadderAction.reorder, LadderAction.startQualifier],
      );
      final json = overTheWire(ladder.toJson());
      final first = (json[AdminLadderJsonKeys.entries]! as List<Object?>).first! as Map;
      expect(first[LadderEntryJsonKeys.position], 1);
      expect(AdminLadder.fromJson(json), ladder);
    });
  });
}
