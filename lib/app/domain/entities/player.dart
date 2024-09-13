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

  Player(
      {required this.id,
      required this.name,
      required this.association,
      required this.position,
      required this.tShirtNumber}) {
    id = dto.id;
    name = dto.name;
    position = dto.position;
    tShirtNumber = dto.tShirtNumber;
    association = dto.association as Team;
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

  Future<DTOPlayer> remove(id) async {
    return await remove(id);
  }
}
