import '../dto/dto_team.dart';

abstract class IDAOTeam {
  Future<int> insertTeam(DTOTeam team); 
  
  Future<int> updateTeam(DTOTeam team); 

  Future<int> deleteTeam(dynamic id);

  Future<DTOTeam?> getTeamById(dynamic id); 

  Future<List<DTOTeam>> getAllTeams();

}
