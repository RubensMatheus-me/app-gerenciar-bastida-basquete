import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';

class Player {
  late dynamic id;
  late String name;
  late String position;
  late int tShirtNumber;
  late Team association;
  late DTOPlayer dto;
  late IDAOPlayer dao;

  Player(this.name, this.association, this.position, this.tShirtNumber) {
    validatePlayerName(name);
    validateAssociationTeam(association);
    validatePlayerPosition(position);
    validateTshirtNumberPlayer(tShirtNumber);
  }

  validatePlayerName(String name) {
    if (name.isEmpty) throw Exception("O jogador deve conter um nome");
  }

  validateAssociationTeam(Team association) {
    if (association != "TeamA" || association != "TeamB")
      throw Exception("O jogador deve ser inserido no time A ou time B");
  }

  validatePlayerPosition(String position) {
    if (position.isEmpty)
      throw Exception("O jogador deve conter uma posição na partida");
  }

  validateTshirtNumberPlayer(int number) {
    if (number < 0 && number > 100)
      throw Exception("O numero do jogador é invalido (0 - 99)");
  }
  Future<DTOPlayer> save() async {
    return await dao.save(dto);
  }

  DTOPlayer remove(id) {
    return remove(id);
  }
}
