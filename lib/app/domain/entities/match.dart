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

  Match({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.fouls,
    required this.turnGame,
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.timer
  });
}
