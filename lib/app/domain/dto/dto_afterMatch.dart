import 'package:basketball_statistics/app/domain/dto/dto_player.dart';

class DTOAfterMatch {
  final int id;
  final int totalPoints;
  final String winner;
  final int totalFouls;
  final int pointsDifference;
  final int durationMatch;
  final List<DTOPlayer> players;
  final int pointsTeamA;
  final int pointsTeamB; 

  DTOAfterMatch({
    required this.id,
    required this.totalPoints,
    required this.winner,
    required this.totalFouls,
    required this.pointsDifference,
    required this.durationMatch,
    required this.players,
    required this.pointsTeamA, 
    required this.pointsTeamB, 
  });

  factory DTOAfterMatch.fromMap(Map<String, dynamic> map, List<DTOPlayer> players) {
    return DTOAfterMatch(
      id: map['id'],
      totalPoints: map['totalPoints'],
      winner: map['winner'],
      totalFouls: map['totalFouls'],
      pointsDifference: map['pointsDifference'],
      durationMatch: map['durationMatch'],
      players: players,
      pointsTeamA: map['pointsTeamA'], 
      pointsTeamB: map['pointsTeamB'], 
    );
  }
}
