import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Player validation', () {
    test('Name validation error', () {
      
    });
  });
}

class PlayerNameTest {
  late dynamic id;
  late String name;

  PlayerNameTest(this.name) {
    validatePlayerName(name);
  }

  validatePlayerName(String name) {
    if (name.isEmpty) throw Exception("O jogador deve conter um nome");
  }
}
class PlayerAssociationTeamTest {
  late dynamic id;
  late Team team;

  PlayerAssociationTeamTest(this.team) {
    validateAssociationTeam(team);
  }

    validateAssociationTeam(Team association) {
    if (association != "TeamA" || association != "TeamB")
      throw Exception("O jogador deve ser inserido no time A ou time B");
  }

}
class PlayerPositionTest {
  late dynamic id;
  late String position;

  PlayerPositionTest(this.position) {
    validatePlayerPosition(position);
  }

  validatePlayerPosition(String position) {
  if (position.isEmpty)
    throw Exception("O jogador deve conter uma posição na partida");
  }
}
class PlayerTshirNumberTest {
  late dynamic id;
  late int tShirtNumber;

  PlayerTshirNumberTest(this.tShirtNumber) {
    validateTshirtNumberPlayer(tShirtNumber);
  }

  validateTshirtNumberPlayer(int number) {
    if (number < 0 && number > 100)
      throw Exception("O numero do jogador é invalido (0 - 99)");
  }
}
