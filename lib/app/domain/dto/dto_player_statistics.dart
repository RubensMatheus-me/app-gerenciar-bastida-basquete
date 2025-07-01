import 'package:datahoops/app/domain/entities/assertiveness_pitch.dart';
import 'package:datahoops/app/domain/entities/player.dart';
import 'package:datahoops/app/domain/entities/player_statistics.dart';
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';

import 'package:datahoops/app/domain/entities/match.dart' as app_match;


class PlayerStatisticsDto {
  final int points;
  final String zonePoint;
  final dynamic assertivenessPitchId;
  final dynamic matchId;
  final dynamic playerId;

  PlayerStatisticsDto({
    required this.points,
    required this.zonePoint,
    required this.assertivenessPitchId,
    required this.matchId,
    required this.playerId,
  });

  factory PlayerStatisticsDto.fromMap(Map<String, dynamic> map) {
    return PlayerStatisticsDto(
      points: map['points'],
      zonePoint: map['zonePoint'],
      assertivenessPitchId: map['assertivenessPitchId'],
      matchId: map['matchId'],
      playerId: map['playerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'points': points,
      'zonePoint': zonePoint,
      'assertivenessPitchId': assertivenessPitchId,
      'matchId': matchId,
      'playerId': playerId,
    };
  }

  PlayerStatistics toEntity({
    required AssertivenessPitch assertivenessPitch,
    required app_match.Match match,
    required Player player,
  }) {
    return PlayerStatistics(
      points: points,
      zonePoint: ZoneType.values.firstWhere((e) => e.toString() == zonePoint),
      idAssertivenessPitch: assertivenessPitch,
      idMatch: match,
      idPlayer: player,
    );
  }

  factory PlayerStatisticsDto.fromEntity(PlayerStatistics stats) {
    return PlayerStatisticsDto(
      points: stats.points,
      zonePoint: stats.zonePoint.toString(),
      assertivenessPitchId: stats.idAssertivenessPitch.id,
      matchId: stats.idMatch.id,
      playerId: stats.idPlayer.id,
    );
  }
}
