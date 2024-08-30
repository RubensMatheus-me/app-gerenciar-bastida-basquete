import 'package:basketball_statistics/app/domain/entities/match.dart';

class AfterMatch extends Match {
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

  AfterMatch({
    required super.id,
    required super.teamA,
    required super.teamB,
    required super.fouls,
    required super.turnGame,
    required super.pointsTeamA,
    required super.pointsTeamB,
    required super.timer,
    required this.durationMatch,
    required this.totalRebounds,
    required this.totalAssists,
    required this.totalTurnovers,
  }) {
    calculateTotalPoints();
    calculateTotalFouls();
    determineWinner();
    calculatePointsDifference();
  }

  calculateTotalPoints() {
    totalPoints = pointsTeamA + pointsTeamB;
  }

  calculateTotalFouls() {
    totalFouls = fouls;
  }

  determineWinner() {
    if (pointsTeamA > pointsTeamB) {
      winner = teamA.name;
      isWinner = true;
    } else {
      winner = teamB.name;
      isWinner = true;
    }
  }

  calculatePointsDifference() {
    pointsDifference = (pointsTeamA - pointsTeamB).abs();
  }
}
