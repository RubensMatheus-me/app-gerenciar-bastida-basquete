import 'package:basketball_statistics/app/domain/dto/dto_match.dart';

abstract class IDAOMatch {
  Future<int> insertMatch(DTOMatch match);

  Future<int> updateMatch(DTOMatch match);

  Future<DTOMatch?> getMatchById(int id);

  Future<List<DTOMatch>> getAllMatches();
  
  Future<List<DTOMatch>> getOngoingMatches();

  Future<DTOMatch?> getMatchForTeams(int teamA, int teamB);
}
