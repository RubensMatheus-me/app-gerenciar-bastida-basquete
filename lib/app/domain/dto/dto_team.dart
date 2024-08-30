import 'package:basketball_statistics/app/domain/entities/player.dart';

class DTOTeam {
  late dynamic id;
  late String name;
  late List<Player> players;

  DTOTeam({this.id, required this.name, required this.players});
}
