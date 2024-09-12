import 'package:flutter_test/flutter_test.dart';

main() {
  group('Team validation', () {
    test('Name validation error', () {
      expect(() => TeamNameTest(name: ''), throwsException);
    });

    test('Player count validation error', () {
      expect(() => TeamPlayerTest(players: []), throwsException);
      expect(() => TeamPlayerTest(players: List.filled(6, PlayerTest())), throwsException);
    });

    test('Valid team creation', () {
      expect(() => TeamNameTest(name: 'Team A'), returnsNormally);
      expect(() => TeamPlayerTest(players: List.filled(3, PlayerTest())), returnsNormally);
    });
  });
}

class TeamNameTest {
  late String name;

  TeamNameTest({required this.name}) {
    validateTeamName(name);
  }

  validateTeamName(String name) {
    if (name.isEmpty) throw Exception("Nome do Time não pode ser vazio");
  }
}

class TeamPlayerTest {
  late List<PlayerTest> players;

  TeamPlayerTest({required this.players}) {
    validateTeamPlayer(players);
  }

  validateTeamPlayer(List<PlayerTest> players) {
    if (players.isEmpty || players.length > 5) {
      throw Exception("O time deve conter entre 1 e 5 jogadores");
    }
  }
}

class PlayerTest {
  late dynamic id;
  late String name;

  PlayerTest({this.id, this.name = "Player"});
}
