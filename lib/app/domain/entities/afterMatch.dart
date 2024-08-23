import 'package:basketball_statistics/app/domain/entities/match.dart';

class AfterMatch extends Match {
  late int totalPoints;
  late DateTime durationMatch;
  late int totalFouls;
  late String winner;

  AfterMatch({required super.id, required super.teamA, required super.teamB, required super.fouls, required super.turnGame, required super.pointsTeamA, required super.pointsTeamB, required super.timer});

}
