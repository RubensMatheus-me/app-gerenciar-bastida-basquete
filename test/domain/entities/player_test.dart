import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Player validation', () {
    test('Name validation error', () {
      expect(() => PlayerNameTest(""), throwsException);
    });

    test('Team name validation error', () {
      expect(() => SimpleTeam(name: ""), throwsException);
    });


    test('Position validation error', () {
      expect(() => PlayerPositionTest(""), throwsException);
    });

    test('T-Shirt number validation error', () {
      expect(() => PlayerTshirNumberTest(-1), throwsException);  
      expect(() => PlayerTshirNumberTest(100), throwsException);
    });

    test('Valid T-Shirt number', () {
      expect(() => PlayerTshirNumberTest(10), returnsNormally);  
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
    if (association.name != "TeamA" && association.name != "TeamB") {
      throw Exception("O jogador deve ser inserido no time A ou time B");
    }
  }
}

class PlayerPositionTest {
  late dynamic id;
  late String position;

  PlayerPositionTest(this.position) {
    validatePlayerPosition(position);
  }

  validatePlayerPosition(String position) {
    if (position.isEmpty) {
      throw Exception("O jogador deve conter uma posição na partida");
    }
  }
}

class PlayerTshirNumberTest {
  late dynamic id;
  late int tShirtNumber;

  PlayerTshirNumberTest(this.tShirtNumber) {
    validateTshirtNumberPlayer(tShirtNumber);
  }

  validateTshirtNumberPlayer(int number) {
    if (number < 0 || number > 99) {
      throw Exception("O número do jogador é inválido (0 - 99)");
    }
  }
}

class SimpleTeam {
  late String name;

  SimpleTeam({required this.name}) {
    validTeamName(name);
  }

  validTeamName(String name) {
    if (name.isEmpty) throw Exception("Nome do Time não pode ser vazio");
  }
}