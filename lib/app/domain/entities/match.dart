import 'package:datahoops/app/domain/enums/enum_match_type.dart';

class Match {
  final dynamic id;
  Duration timer;
  final int maxPoints;
  String? winner;
  final MatchType matchType;

  Match({
    required this.id,
    this.timer = Duration.zero,
    required this.maxPoints,
    required this.winner,
    required this.matchType,
  });
}