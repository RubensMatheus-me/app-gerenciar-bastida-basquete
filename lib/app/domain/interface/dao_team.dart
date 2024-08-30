import '../dto/dto_team.dart';
import '../entities/team.dart';

abstract class IDAOTeam {
  DTOTeam save(DTOTeam dto);

  DTOTeam remove(dynamic id);

  Future<List<Team>> search();
}
