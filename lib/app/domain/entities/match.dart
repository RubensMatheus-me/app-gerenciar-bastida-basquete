import 'dart:async';

import 'package:basketball_statistics/app/domain/entities/afterMatch.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';

class Match {
  //3x3
  late dynamic id;
  late Team teamA;
  late Team teamB;
  late int fouls = 0;
  late int turnGame = 1;
  late int pointsTeamA = 0;
  late int pointsTeamB = 0;
  late DateTime timer;
  bool isBallInPlay = true;

  Match({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.fouls,
    required this.turnGame,
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.timer

  }) {
    validateTeams();
  }

  validateTeams() {
    if(teamA == teamB) throw Exception("Os times A e B não podem ser o mesmo time");
  }

  startMatch(DateTime startTime, DateTime endTime){
    validateMatchDuration(startTime, endTime);
  }

  validateMatchDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    if(duration >Duration(minutes: 10)) throw Exception("A partida não pode ultrapassar 10 minutos");
  }

  commitFouls() {
    fouls++;
    validateFouls();
  }

  validateFouls() {
    if(fouls >= 7) throw Exception("A equipe já atingiu o limite de faltas");
  }

  scorePoints(int points, Team team) {
    if(team == teamA) {
      pointsTeamA += points;
    }else if (team == teamB) {
      pointsTeamB += points;
    }
    validatePoints();
  }
  
  validatePoints() {
    if(pointsTeamA >= 21 || pointsTeamB >= 21) throw Exception("A partida terminou porque uma equipe alcançou 21 pontos");
  }

  makeSubstitution(Player outPlayer, Player inPlayer) {
    validateSubstitution(isBallInPlay);
    //implementar
  }
  
  validateSubstitution(bool isBallInPlay) {
    if(isBallInPlay) throw Exception("Substituições só podem ser feitas quando a bola não está em jogo");
  }
}
