import 'package:basketball_statistics/app/domain/entities/player.dart';

class Team {
  late dynamic id;
  late String name;
  late List<Player>? players;

  Team(String name) {
    validTeamName(name);
  }

  validTeamName(String name) {
    if (name.isEmpty) throw Exception("Nome do Time não pode ser vazio");
  }
}
