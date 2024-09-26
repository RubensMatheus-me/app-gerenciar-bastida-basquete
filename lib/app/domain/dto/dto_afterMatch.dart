class DTOAfterMatch {
  int id;
  int totalPoints;
  DateTime durationMatch;
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

  // Método para converter de Map para DTOAfterMatch
  factory DTOAfterMatch.fromMap(Map<String, dynamic> map) {
    return DTOAfterMatch(
      id: map['id'],
      totalPoints: map['totalPoints'],
      durationMatch: DateTime.parse(map['durationMatch']),
      totalFouls: map['totalFouls'],
      winner: map['winner'],
      pointsDifference: map['pointsDifference'],
      totalRebounds: map['totalRebounds'],
      totalAssists: map['totalAssists'],
      totalTurnovers: map['totalTurnovers'],
      isWinner: map['isWinner'] == 1, // Convertendo int para bool
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalPoints': totalPoints,
      'durationMatch': durationMatch.toIso8601String(),
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
