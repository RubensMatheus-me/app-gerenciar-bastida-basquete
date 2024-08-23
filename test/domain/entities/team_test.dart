import 'dart:math';

import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Team validation', () {
    test('Name validation error', () {
      expect(() => Team(""), throwsException);
    });
    test('Name validation accept', () {
      expect(() => Team("Os Rapazes"), returnsNormally);
    });
  });
}
