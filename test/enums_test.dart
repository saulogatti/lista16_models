import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

void main() {
  test('EventStatus: valores JSON estáveis e ida e volta', () {
    expect(EventStatus.values.map((item) => item.toJson()), [
      'scheduled',
      'inProgress',
      'finished',
    ]);
    for (final item in EventStatus.values) {
      expect(EventStatus.fromJson(item.toJson()), item);
    }
  });

  test('ChallengeKind: valores JSON estáveis e ida e volta', () {
    expect(ChallengeKind.values.map((item) => item.toJson()), ['position', 'entry']);
    for (final item in ChallengeKind.values) {
      expect(ChallengeKind.fromJson(item.toJson()), item);
    }
  });

  test('RaceOutcome: valores JSON estáveis e ida e volta', () {
    expect(RaceOutcome.values.map((item) => item.toJson()), [
      'finishedBehind',
      'falseStart',
      'crossedCenterLine',
      'tiebreak',
      'coinToss',
      'deadlineExpired',
    ]);
    for (final item in RaceOutcome.values) {
      expect(RaceOutcome.fromJson(item.toJson()), item);
    }
  });

  test('valor desconhecido ou que não é texto lança FormatException', () {
    expect(() => EventStatus.fromJson('cancelled'), throwsFormatException);
    expect(() => ChallengeKind.fromJson(null), throwsFormatException);
    expect(() => RaceOutcome.fromJson('draw'), throwsFormatException);
  });
}
