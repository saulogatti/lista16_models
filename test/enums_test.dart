import 'package:lista16_models/lista16_models.dart';
import 'package:test/test.dart';

void main() {
  test('EventStatus: valores JSON estáveis e ida e volta', () {
    expect(EventStatus.values.map((item) => item.toJson()), [
      'scheduled',
      'inProgress',
      'finished',
      'cancelled',
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
      'didNotFinish',
      'noShow',
    ]);
    for (final item in RaceOutcome.values) {
      expect(RaceOutcome.fromJson(item.toJson()), item);
    }
  });

  /// Valores JSON de [values], na ordem, e ida e volta por [fromJson].
  void stable<T extends Enum>(
    List<T> values,
    String Function(T) toJson,
    T Function(Object?) fromJson,
    List<String> expected,
  ) {
    expect(values.map(toJson), expected);
    for (final item in values) {
      expect(fromJson(toJson(item)), item);
    }
  }

  test('enums do desafio e do movimento: valores JSON estáveis e ida e volta', () {
    stable(ChallengeStatus.values, (i) => i.toJson(), ChallengeStatus.fromJson, [
      'pending',
      'closed',
      'cancelled',
    ]);
    stable(ChallengeOrigin.values, (i) => i.toJson(), ChallengeOrigin.fromJson, [
      'scheduled',
      'atEvent',
    ]);
    stable(MovementCause.values, (i) => i.toJson(), MovementCause.fromJson, [
      'challenge',
      'deadlineExpired',
      'noShow',
      'qualifier',
      'left',
      'duoChange',
      'inactivity',
      'manualAdjustment',
      'initialLoad',
    ]);
    stable(TiebreakCriterion.values, (i) => i.toJson(), TiebreakCriterion.fromJson, [
      'reaction',
      'sixtyFeet',
      'hundredMeters',
      'trapSpeed',
    ]);
    stable(ChallengeAction.values, (i) => i.toJson(), ChallengeAction.fromJson, [
      'recordRace',
      'expireDeadline',
      'recordNoShow',
      'cancel',
    ]);
    stable(DuoAction.values, (i) => i.toJson(), DuoAction.fromJson, ['challenge', 'leave']);
    stable(LadderAction.values, (i) => i.toJson(), LadderAction.fromJson, [
      'loadInitial',
      'reorder',
      'startQualifier',
    ]);
  });

  test('valor desconhecido ou que não é texto lança FormatException', () {
    expect(() => EventStatus.fromJson('postponed'), throwsFormatException);
    expect(() => ChallengeKind.fromJson(null), throwsFormatException);
    expect(() => RaceOutcome.fromJson('draw'), throwsFormatException);
  });
}
