import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_Team.dart';

class Team {
  late dynamic id;
  late String name;
  //late List<Player> players;
  late DTOTeam dto;
  late IDAOTeam dao;

  Team({
    required this.name,
    //required this.players,
    required this.id,
  }) {
    // Não inicializar dto aqui, deve ser feito externamente ou em outro local
    validTeamName(name);
    //validateTeamPlayer(players);
  }

  String? validTeamName(String name) {
    if (name.isEmpty) {
      return "Nome do time não pode ser vazio";
    }
    return null;
  }

  String? validateTeamPlayer(List<Player> players) {
    if (players.isEmpty || players.length < 5) {
      return "O time deve conter a quantidade correta de jogadores para o início da partida";
    }
    return null;
  }
}
