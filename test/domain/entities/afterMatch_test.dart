import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AfterMatch validation', () {
    test('Winner validation error', () {
      final teamA = TeamTest(name: 'TeamA', players: [
        PlayerNameTest(name: 'Player1'),
        PlayerNameTest(name: 'Player2'),
        PlayerNameTest(name: 'Player3')
      ]);
      final teamB = TeamTest(name: 'TeamB', players: [
        PlayerNameTest(name: 'Player4'),
        PlayerNameTest(name: 'Player5'),
        PlayerNameTest(name: 'Player6')
      ]);
      expect(() => AfterMatchWinnerValidationTest(
        pointsTeamA: 10,
        pointsTeamB: 10,
        teamA: teamA,
        teamB: teamB
      ), throwsException);
    });

    test('Points difference validation error', () {
      final teamA = TeamTest(name: 'TeamA', players: [
        PlayerNameTest(name: 'Player1'),
        PlayerNameTest(name: 'Player2'),
        PlayerNameTest(name: 'Player3')
      ]);
      final teamB = TeamTest(name: 'TeamB', players: [
        PlayerNameTest(name: 'Player4'),
        PlayerNameTest(name: 'Player5'),
        PlayerNameTest(name: 'Player6')
      ]);
      expect(() => AfterMatchPointsDifferenceValidationTest(
        pointsTeamA: 20,
        pointsTeamB: 20,
        teamA: teamA,
        teamB: teamB
      ), throwsException);
    });

    test('Total fouls validation error', () {
      expect(() => AfterMatchTotalFoulsValidationTest(
        fouls: 8
      ), throwsException);
    });
  });
}

class AfterMatchWinnerValidationTest {
  late int pointsTeamA;
  late int pointsTeamB;
  late TeamTest teamA;
  late TeamTest teamB;

  AfterMatchWinnerValidationTest({
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.teamA,
    required this.teamB,
  }) {
    validateWinner();
  }

  void validateWinner() {
    if (pointsTeamA == pointsTeamB) {
      throw Exception("Não pode haver empate, deve haver um vencedor.");
    }
  }
}

class AfterMatchPointsDifferenceValidationTest {
  late int pointsTeamA;
  late int pointsTeamB;
  late TeamTest teamA;
  late TeamTest teamB;

  AfterMatchPointsDifferenceValidationTest({
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.teamA,
    required this.teamB,
  }) {
    validatePointsDifference();
  }

  void validatePointsDifference() {
    final difference = (pointsTeamA - pointsTeamB).abs();
    if (difference == 0) {
      throw Exception("A diferença de pontos não pode ser zero.");
    }
  }
}

class AfterMatchTotalFoulsValidationTest {
  late int fouls;

  AfterMatchTotalFoulsValidationTest({required this.fouls}) {
    validateTotalFouls();
  }

  void validateTotalFouls() {
    if (fouls > 7) {
      throw Exception("Número de faltas excedido (máximo 7 faltas).");
    }
  }
}

class PlayerNameTest {
  late String name;

  PlayerNameTest({required this.name}) {
    validatePlayerName(name);
  }

  void validatePlayerName(String name) {
    if (name.isEmpty) throw Exception("O jogador deve conter um nome.");
  }
}

class TeamTest {
  late String name;
  late List<PlayerNameTest> players;

  TeamTest({required this.name, required this.players}) {
    validateTeamName();
    validateTeamPlayers();
  }

  void validateTeamName() {
    if (name.isEmpty) {
      throw Exception("O nome da equipe não pode estar vazio.");
    }
    if (name.length < 3) {
      throw Exception("O nome da equipe deve ter pelo menos 3 caracteres.");
    }
  }

  void validateTeamPlayers() {
    if (players.length != 3) {
      throw Exception("O time deve ter exatamente 3 jogadores.");
    }
  }
}
