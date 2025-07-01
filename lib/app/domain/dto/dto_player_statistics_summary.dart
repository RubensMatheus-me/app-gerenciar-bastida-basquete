class PlayerStatisticsSummaryDto {
  int playerId;
  String playerName;
  int totalPoints;
  int totalHits;
  int totalMisses;
  Map<String, int> pointsByZone;

  PlayerStatisticsSummaryDto({
    required this.playerId,
    required this.playerName,
    this.totalPoints = 0,
    this.totalHits = 0,
    this.totalMisses = 0,
    Map<String, int>? pointsByZone,
  }) : pointsByZone = pointsByZone ?? {};
}
