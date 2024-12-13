class DTOPlayer {
  int? id;
  String name;
  String position;
  int tShirtNumber;
  int? rebounds;
  int? assists;
  int? points;
  int teamId;

  DTOPlayer(
      {this.id,
      required this.name,
      required this.position,
      required this.tShirtNumber,
      required this.teamId,
      this.points,
      this.assists,
      this.rebounds});

  Map<String, dynamic> toMap() {
    return {  
      'id': id,
      'name': name,
      'position': position,
      'tShirtNumber': tShirtNumber,
      'assists': assists,
      'rebounds': rebounds,
      'teamId': teamId,
      'points': points
    };
  }

  factory DTOPlayer.fromMap(Map<String, dynamic> map) {
    return DTOPlayer(
      id: map['id'],
      name: map['name'] ?? 'nome?',
      position: map['position'] ?? 'posição?',
      tShirtNumber: map['tShirtNumber'],
      assists: map['assists'],
      rebounds: map['rebounds'],
      teamId: map['teamId'],
      points: map['points'],
    );
  }
}
