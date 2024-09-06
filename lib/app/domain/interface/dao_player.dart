import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';

abstract class IDAOPlayer {
  Future<DTOPlayer> save(DTOPlayer dto);

  Future<DTOPlayer> remove(dynamic id);

  Future<List<Player>> search();
}
