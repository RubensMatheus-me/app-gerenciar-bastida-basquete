import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';

class DTOMatch {
  late dynamic id;
  late DTOTeam teamA;
  late DTOTeam teamB;
  late int fouls;
  late int turnGame;
  late int pointsTeamA;
  late int pointsTeamB;
  late DateTime timer;
  late bool matchStarted;

  DTOMatch(
      {this.id,
      required this.teamA,
      required this.teamB,
      this.fouls = 0,
      this.turnGame = 1,
      this.pointsTeamA = 0,
      this.pointsTeamB = 0,
      required this.timer,
      this.matchStarted = true});
}
