import '../dto/dto_team.dart';
import '../entities/team.dart';

abstract class IDAOTeam {
  save(DTOTeam dto);

  Future<List<Team>> search();
}
