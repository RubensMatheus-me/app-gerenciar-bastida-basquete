import 'package:basketball_statistics/app/domain/entities/player.dart';

class Team {
  late dynamic id;
  late String name;
  late List<Player>? players;

  Team(this.name, this.players) {
    validTeamName(name);
    validateTeamPlayer();
  }

  validTeamName(String name) {
    if (name.isEmpty) throw Exception("Nome do Time não pode ser vazio");
  }

  validateTeamPlayer() {
    if(players == null || players!.length != 3) throw Exception("O time deve ter exatamente 3 jogadores");
  }
}
