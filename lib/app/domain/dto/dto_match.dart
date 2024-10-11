class DTOMatch {
  int? id;
  int teamAId;
  int teamBId;
  int foulsTeamA;
  int foulsTeamB;
  int pointsTeamA;
  int pointsTeamB;
  int timer;
  int assists;
  int turnGame;
  bool isCompleted;

  DTOMatch({
    this.id,
    required this.teamAId,
    required this.teamBId,
    required this.foulsTeamA,
    required this.foulsTeamB,
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.assists,
    required this.timer,
    required this.turnGame,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'teamAId': teamAId,
      'teamBId': teamBId,
      'foulsTeamA': foulsTeamA,
      'foulsTeamB': foulsTeamB,
      'pointsTeamA': pointsTeamA,
      'pointsTeamB': pointsTeamB,
      'assists': assists,
      'timer': timer,
      'turnGame': turnGame,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory DTOMatch.fromMap(Map<String, dynamic> map) {
    return DTOMatch(
      id: map['id'],
      teamAId: map['teamAId'],
      teamBId: map['teamBId'],
      foulsTeamA: map['foulsTeamA'],
      foulsTeamB: map['foulsTeamB'],
      pointsTeamA: map['pointsTeamA'],
      pointsTeamB: map['pointsTeamB'],
      assists: map['assists'],
      turnGame: map['turnGame'] ?? 1,
      timer: map['timer'] ?? 0,
      isCompleted: map['isCompleted'] == 1,
    );
  }

  static DTOMatch createNewMatch(int teamAId, int teamBId) {
    return DTOMatch(
      teamAId: teamAId,
      teamBId: teamBId,
      foulsTeamA: 0,
      foulsTeamB: 0,
      pointsTeamA: 0,
      pointsTeamB: 0,
      assists: 0,
      timer: 0,
      turnGame: 1,
      isCompleted: false,
    );
  }
}
