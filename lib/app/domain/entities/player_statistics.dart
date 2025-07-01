import 'package:datahoops/app/domain/entities/assertiveness_pitch.dart';
import 'package:datahoops/app/domain/entities/player.dart';
import 'package:datahoops/app/domain/entities/match.dart';
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';

class PlayerStatistics {
  final int points;
  final ZoneType zonePoint;
  final AssertivenessPitch idAssertivenessPitch;
  final Match idMatch;
  final Player idPlayer;

  PlayerStatistics({
    required this.points,
    required this.zonePoint,
    required this.idAssertivenessPitch,
    required this.idMatch,
    required this.idPlayer,
  });
}
