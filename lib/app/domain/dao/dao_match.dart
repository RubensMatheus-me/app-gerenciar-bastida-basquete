import 'package:datahoops/app/domain/dto/dto_match.dart';

abstract class IMatchDao {
  Future<int> insert(MatchDto match);
  Future<int> update(MatchDto match);
  Future<int> delete(dynamic id);
  Future<MatchDto?> getById(dynamic id);
  Future<List<MatchDto>> getAll();
}
