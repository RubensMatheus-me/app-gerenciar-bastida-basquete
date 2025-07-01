class PlayerZoneStatsDto {
  final int playerId;
  final String playerName;
  final String zonePoint;
  final int assertivenessPitchId;
  final int totalAttempts;
  final int totalPoints;

  PlayerZoneStatsDto({
    required this.playerId,
    required this.playerName,
    required this.zonePoint,
    required this.assertivenessPitchId,
    required this.totalAttempts,
    required this.totalPoints,
  });
}
