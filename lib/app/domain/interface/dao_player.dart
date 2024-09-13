import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';

abstract class IDAOPlayer {
  save(DTOPlayer dto);

  remove(dynamic id);

  Future<List<Player>> search();
}
