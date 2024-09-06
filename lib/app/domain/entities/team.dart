import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_Team.dart';

class Team {
  late dynamic id;
  late String name;
  late List<Player> players;
  late DTOTeam dto;
  late IDAOTeam dao;

  Team({
    required this.name,
    required this.players,
    required this.dao,
    required this.dto,
  }) {
    validTeamName(name);
    validateTeamPlayer(players);
    id = dto.id;
    name = dto.name;
    players = dto.players;
  }

  validTeamName(String name) {
    if (name.isEmpty) throw Exception("Nome do Time não pode ser vazio");
  }

  validateTeamPlayer(List<Player> players) {
    if (players.isEmpty || players.length >= 5)
      throw Exception(
          "O time deve conter a quantidade correta de jogadores para o inicio de partida");
  }

  Future<DTOTeam> save() async {
    return await dao.save(dto);
  }

  DTOTeam remove(id) {
    return remove(id);
  }
}
