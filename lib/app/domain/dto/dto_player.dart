class DTOPlayer {
  int id;
  String name;
  String position;
  int tShirtNumber;
  int teamId;

  DTOPlayer({
    required this.id,
    required this.name,
    required this.position,
    required this.tShirtNumber,
    required this.teamId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'tShirtNumber': tShirtNumber,
      'teamId': teamId,
    };
  }

  factory DTOPlayer.fromMap(Map<String, dynamic> map) {
    return DTOPlayer(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      tShirtNumber: map['tShirtNumber'],
      teamId: map['teamId'],
    );
  }
}
