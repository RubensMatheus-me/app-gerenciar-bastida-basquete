class DTOMatch {
  int id;
  int teamAId;
  int teamBId;
  int foulsTeamA;
  int foulsTeamB;
  int pointsTeamA;
  int pointsTeamB;
  int assists;
  int turnovers;
  DateTime startTime;
  DateTime? endTime;
  bool isCompleted;

  DTOMatch({
    required this.id,
    required this.teamAId,
    required this.teamBId,
    required this.foulsTeamA,
    required this.foulsTeamB,
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.assists,
    required this.turnovers,
    required this.startTime,
    this.endTime,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'foulsTeamA': foulsTeamA,
      'foulsTeamB': foulsTeamB,
      'pointsTeamA': pointsTeamA,
      'pointsTeamB': pointsTeamB,
      'assists': assists,
      'turnovers': turnovers,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
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
      turnovers: map['turnovers'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
