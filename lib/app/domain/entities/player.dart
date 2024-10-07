import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';

class Player {
  late dynamic? id;
  late String name;
  late String position;
  late int tShirtNumber;
  late int teamId;
  late int rebounds;
  late int assists;
  late DTOPlayer dto;
  late IDAOPlayer dao;

  Player(
      {this.id,
      required this.name,
      required this.teamId,
      required this.position,
      required this.tShirtNumber}) {
    id = dto.id;
    name = dto.name;
    position = dto.position;
    tShirtNumber = dto.tShirtNumber;
    teamId = dto.teamId;
    validatePlayerName(name);
    validatePlayerPosition(position);
    validateTshirtNumberPlayer(tShirtNumber);
  }

  validatePlayerName(String name) {
    if (name.isEmpty) throw Exception("O jogador deve conter um nome");
  }

  validatePlayerPosition(String position) {
    if (position.isEmpty)
      throw Exception("O jogador deve conter uma posição na partida");
  }

  validateTshirtNumberPlayer(int number) {
    if (number < 0 && number > 100)
      throw Exception("O numero do jogador é invalido (0 - 99)");
  }
}
