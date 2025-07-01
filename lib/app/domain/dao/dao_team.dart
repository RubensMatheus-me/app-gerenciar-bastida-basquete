import 'package:datahoops/app/domain/dto/dto_team.dart';

abstract class ITeamDao {
  Future<int> insert(TeamDto team);
  Future<int> update(TeamDto team);
  Future<int> delete(dynamic id);
  Future<TeamDto?> getById(dynamic id);
  Future<List<TeamDto>> getAll();
}
