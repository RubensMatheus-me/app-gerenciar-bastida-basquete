import 'package:datahoops/app/domain/entities/match.dart';
import 'package:datahoops/app/domain/enums/enum_match_type.dart';

class MatchDto {
  final dynamic id;
  final int timer;
  final int maxPoints;
  final String? winner;
  final int matchTypeIndex;

  MatchDto({
    required this.id,
    required this.timer,
    required this.maxPoints,
    required this.winner,
    required this.matchTypeIndex,
  });

  factory MatchDto.fromEntity(Match match) {
    return MatchDto(
      id: match.id,
      timer: match.timer.inSeconds,
      maxPoints: match.maxPoints,
      winner: match.winner,
      matchTypeIndex: match.matchType.index,
    );
  }

  Match toEntity() {
    return Match(
      id: id,
      timer: Duration(seconds: timer),
      maxPoints: maxPoints,
      winner: winner,
      matchType: MatchType.values[matchTypeIndex],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'timer' : timer,
    'maxPoints': maxPoints,
    'winner': winner,
    'matchTypeIndex': matchTypeIndex,
  };

  factory MatchDto.fromMap(Map<String, dynamic> map) {
    return MatchDto(
      id: map['id'],
      timer: map['timer'],
      maxPoints: map['maxPoints'],
      winner: map['winner'],
      matchTypeIndex: map['matchTypeIndex'],
    );
  }
}
