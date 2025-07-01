import 'package:datahoops/app/domain/dto/dto_player.dart';

abstract class IPlayerDao {
  Future<int> insert(PlayerDto player);
  Future<int> update(PlayerDto player);
  Future<int> delete(dynamic id);
  Future<PlayerDto?> findById(dynamic id);
  Future<List<PlayerDto>> findAll();
  Future<List<PlayerDto>> getPlayerByTeam(dynamic teamId);
}
 