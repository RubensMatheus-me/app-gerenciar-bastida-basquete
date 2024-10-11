class DTOAfterMatch {
  int id;
  int totalPoints;
  int durationMatch;
  int totalFouls;
  String winner;
  int pointsDifference;
  int totalRebounds;
  int totalAssists;
  int totalTurnovers;
  bool isWinner;

  DTOAfterMatch({
    required this.id,
    required this.totalPoints,
    required this.durationMatch,
    required this.totalFouls,
    required this.winner,
    required this.pointsDifference,
    required this.totalRebounds,
    required this.totalAssists,
    required this.totalTurnovers,
    required this.isWinner,
  });

  factory DTOAfterMatch.fromMap(Map<String, dynamic> map) {
    return DTOAfterMatch(
      id: map['id'] ?? 0,
      totalPoints: map['totalPoints'] ?? 0,
      durationMatch: map['durationMatch'] ?? 0,
      totalFouls: map['totalFouls'] ?? 0,
      winner: map['winner'] ?? '',
      pointsDifference: map['pointsDifference'] ?? 0,
      totalRebounds: map['totalRebounds'] ?? 0,
      totalAssists: map['totalAssists'] ?? 0,
      totalTurnovers: map['totalTurnovers'] ?? 0,
      isWinner: (map['isWinner'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalPoints': totalPoints,
      'durationMatch': durationMatch,
      'totalFouls': totalFouls,
      'winner': winner,
      'pointsDifference': pointsDifference,
      'totalRebounds': totalRebounds,
      'totalAssists': totalAssists,
      'totalTurnovers': totalTurnovers,
      'isWinner': isWinner ? 1 : 0,
    };
  }
}
