import 'dart:async';

import 'package:basketball_statistics/app/domain/entities/afterMatch.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
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
  //late bool isBallInPlay;
  late bool matchStarted;
  late bool isCompleted;

  Match(
      {required this.id,
      required this.teamA,
      required this.teamB,
      required this.fouls,
      required this.turnGame,
      required this.pointsTeamA,
      required this.pointsTeamB,
      required this.isCompleted,
      required this.timer}) {
    validateTeams();
  }

  validateTeams() {
    if (teamA == teamB) {
      throw Exception("Os times A e B não podem ser o mesmo time");
    }
    //validateTeamPlayers(teamA);
    //validateTeamPlayers(teamB);
  }

//validateTeamPlayers(Team team) {
//  if (team.players.length < 3 || team.players.length > 4) {
//    throw Exception("Cada time deve ter entre 3 e 4 jogadores (3 titulares e 1 reserva)");
//  }
//}

  startMatch(DateTime startTime, DateTime endTime) {
    if (matchStarted) throw Exception("A partida já foi iniciada");
    matchStarted = true;
    validateMatchDuration(startTime, endTime);
  }

  validateMatchDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    if (duration > Duration(minutes: 10)) {
      throw Exception("A partida não pode ultrapassar 10 minutos");
    }
  }

  scorePoints(int points, Team team) {
    if (team == teamA) {
      pointsTeamA += points;
    } else if (team == teamB) {
      pointsTeamB += points;
    }
    validatePoints();
  }

  validatePoints() {
    if (pointsTeamA >= 21 || pointsTeamB >= 21)
      throw Exception(
          "A partida terminou porque uma equipe alcançou 21 pontos");
  }

  validateFouls() {
    if (fouls >= 7) throw Exception("A equipe já atingiu o limite de faltas");
  }

  endMatch() {
    //parar cronometro e definir vencedor ou tempo extra
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

  /*
  makeSubstitution(Player outPlayer, Player inPlayer) {
    validateSubstitution(isBallInPlay);
  }

  validateSubstitution(bool isBallInPlay) {
    if (isBallInPlay)
      throw Exception(
          "Substituições só podem ser feitas quando a bola não está em jogo");
  }
  */
}
