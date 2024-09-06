import '../dto/dto_team.dart';
import '../entities/team.dart';

abstract class IDAOTeam {
  Future<DTOTeam> save(DTOTeam dto);

  Future<DTOTeam> remove(dynamic id);

  Future<List<Team>> search();
}
