import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';

class Player {
  late dynamic id;
  late String? name;
  late String? position;
  late int? tShirtNumber;
  late int? teamId;
  late int rebounds;
  late int assists;
  late DTOPlayer dto; // Declare como late, mas inicialize no construtor
  late IDAOPlayer dao;

  Player(
      {this.id,
      this.name,
      this.teamId,
      this.position,
      this.tShirtNumber,
      DTOPlayer? dto}) {
    this.dto =
        dto ?? DTOPlayer(name: '', position: '', tShirtNumber: 0, teamId: 0);
    this.name = this.dto.name;
    this.position = this.dto.position;
    this.tShirtNumber = this.dto.tShirtNumber;
    this.teamId = this.dto.teamId;

    validatePlayerName(this.name!);
    validatePlayerPosition(this.position!);
    validateTshirtNumberPlayer(this.tShirtNumber!);
  }

  String? validatePlayerName(String? name) {
    if (name == null || name.isEmpty) {
      return "O jogador deve conter um nome";
    }
    return null;
  }

  String? validatePlayerPosition(String? position) {
    if (position == null || position.isEmpty) {
      return "O jogador deve conter uma posição na partida";
    }
    return null;
  }

  String? validateTshirtNumberPlayer(int? number) {
    if (number == null || number < 0 || number > 99) {
      return "O número do jogador é inválido (0 - 99)";
    }
    return null;
  }
}
