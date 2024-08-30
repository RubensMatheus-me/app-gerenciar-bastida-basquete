class DTOAfterMatch {
  late dynamic id;
  late int totalPoints;
  late DateTime durationMatch;
  late int totalFouls;
  late String winner;
  late int pointsDifference;
  late int totalRebounds;
  late int totalAssists;
  late int totalTurnovers;
  late bool isWinner;

  DTOAfterMatch(
      {this.id,
      required this.totalPoints,
      required this.durationMatch,
      required this.totalFouls,
      required this.winner,
      required this.isWinner,
      required this.pointsDifference,
      required this.totalRebounds,
      required this.totalAssists,
      required this.totalTurnovers});
}
