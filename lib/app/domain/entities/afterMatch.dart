import 'package:basketball_statistics/app/domain/entities/match.dart';

class AfterMatch extends Match {
  @override
  late dynamic id;
  late dynamic matchId;
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
    validateDurationMatch();
    validateTotalFouls();
    validateStatistics();
    validateConsistency();
  }


  calculateTotalPoints() {
    totalPoints = pointsTeamA + pointsTeamB;
  }


  calculateTotalFouls() {
    totalFouls = fouls;
  }


  determineWinner() {
    if (pointsTeamA == pointsTeamB) {
      winner = "Empate";
      isWinner = false;
    } else if (pointsTeamA > pointsTeamB) {
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

  validateDurationMatch() {
    if (durationMatch.isBefore(timer)) {
      throw Exception("A duração da partida não pode ser anterior ao início.");
    }
  }


  validateTotalFouls() {
    if (totalFouls < 0) {
      throw Exception("O total de faltas não pode ser negativo.");
    }
  }


  validateStatistics() {
    if (totalPoints < 0 || totalRebounds < 0 || totalAssists < 0 || totalTurnovers < 0) {
      throw Exception("Estatísticas da partida não podem conter valores negativos.");
    }
  }


  validateConsistency() {
    if (totalPoints != pointsTeamA + pointsTeamB) {
      throw Exception("Os pontos totais são inconsistentes com os pontos das equipes.");
    }
  }
}
