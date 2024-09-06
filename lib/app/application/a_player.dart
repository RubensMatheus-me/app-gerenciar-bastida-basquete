import 'package:basketball_statistics/app/database/sqlite/dao_player.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';

class APlayer {
  late Player player;
  IDAOPlayer dao = DaoPlayer();

  APlayer({required DTOPlayer dto}) {
    player = Player(dto.name, dto.association, dto.position, dto.tShirtNumber);
  }

  save() {
    player.save();
  }
}
