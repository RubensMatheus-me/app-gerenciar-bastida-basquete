import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';

abstract class IDAOPlayer {
  Future<int> insertPlayer(DTOPlayer player);

  Future<List<DTOPlayer>> getPlayersByTeam(int teamId);

  Future<int> updatePlayer(DTOPlayer player);

  Future<int> deletePlayer(dynamic id);
}
