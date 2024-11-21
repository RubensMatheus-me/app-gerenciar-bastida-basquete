import 'package:basketball_statistics/app/domain/entities/basketball.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';

class Match {
  //3x3
  late dynamic id;
  late Team teamA;
  late Team teamB;
  late int foulsTeamA;
  late int fouls;
  late int turnGame;
  late int pointsTeamA;
  late int pointsTeamB;
  late int rebounds;
  late int assists;
  late int turnovers;
  late DateTime timer;
  late Basketball basketball;
  late bool matchStarted;
  late bool isCompleted;

  Match({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.fouls,
    required this.turnGame,
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.isCompleted,
    required this.timer,
    required this.basketball, // Certifique-se de inicializar a bola de basquete
  }) {
    validateTeams();
  }

  validateTeams() {
    if (teamA == teamB) {
      throw Exception("Os times A e B não podem ser o mesmo time");
    }
  }

  void scorePoints(int points, Team team) {
    if (team == teamA) {
      pointsTeamA += points;
    } else if (team == teamB) {
      pointsTeamB += points;
    }
    validatePoints();
  }

  void scoreWithBall() {
    /*
    if (basketball.player != null) {
      int points = basketball.determinePoints();
      scorePoints(points, basketball.player!.team);
    }
    */
  }

  startMatch(DateTime startTime, DateTime endTime) {
    if (matchStarted) throw Exception("A partida já foi iniciada");
    matchStarted = true;
    validateMatchDuration(startTime, endTime);
  }

  validateMatchDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    if (duration > const Duration(minutes: 10)) {
      throw Exception("A partida não pode ultrapassar 10 minutos");
    }
  }

  validatePoints() {
    if (pointsTeamA >= 21 || pointsTeamB >= 21) {
      throw Exception("A partida terminou porque uma equipe alcançou 21 pontos");
    }
  }

  validateFouls() {
    if (fouls >= 7) throw Exception("A equipe já atingiu o limite de faltas");
  }

  endMatch() {
    // parar cronometro e definir vencedor ou tempo extra
  }

  commitFouls() {
    fouls++;
    validateFouls();
  }

  commitAssists() {
    assists++;
  }

  commitRebounds() {
    rebounds++;
  }

  commitTurnover() {
    turnovers++;
  }
}
