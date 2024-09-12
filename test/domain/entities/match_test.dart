import 'package:flutter_test/flutter_test.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:basketball_statistics/app/domain/entities/match.dart';

void main() {
  group('Match validation', () {
    test('Teams validation error', () {
      final teamA = Team(name: 'TeamA', players: [Player(name: 'Player1'), Player(name: 'Player2'), Player(name: 'Player3'), Player(name: 'Player4'), Player(name: 'Player5')]);
      final teamB = Team(name: 'TeamA', players: [Player(name: 'Player6'), Player(name: 'Player7'), Player(name: 'Player8'), Player(name: 'Player9'), Player(name: 'Player10')]);
      expect(() => TeamValidationTest(teamA: teamA, teamB: teamB), throwsException);
    });

    test('Match duration validation error', () {
      final startTime = DateTime.now();
      final endTime = startTime.add(Duration(minutes: 11));
      expect(() => MatchDurationValidationTest(startTime: startTime, endTime: endTime), throwsException);
    });

    test('Fouls validation error', () {
      expect(() => FoulsValidationTest(fouls: 7), throwsException);
    });

    test('Points validation error', () {
      expect(() => PointsValidationTest(pointsTeamA: 21, pointsTeamB: 20), throwsException);
      expect(() => PointsValidationTest(pointsTeamA: 20, pointsTeamB: 21), throwsException);
    });

    test('Match already started validation error', () {
      expect(() => MatchStartedValidationTest(matchStarted: true), throwsException);
    });

    test('Team player count validation', () {
      final teamWithFewPlayers = Team(name: 'TeamA', players: [Player(name: 'Player1'), Player(name: 'Player2')]);
      final teamWithManyPlayers = Team(name: 'TeamB', players: [Player(name: 'Player1'), Player(name: 'Player2'), Player(name: 'Player3'), Player(name: 'Player4'), Player(name: 'Player5')]);
      
      expect(() => TeamPlayerCountValidationTest(players: teamWithFewPlayers.players), throwsException);
      expect(() => TeamPlayerCountValidationTest(players: teamWithManyPlayers.players), throwsException);
    });
  });
}

class TeamValidationTest {
  late Team teamA;
  late Team teamB;

  TeamValidationTest({required this.teamA, required this.teamB}) {
    validateTeams();
  }

  void validateTeams() {
    if (teamA == teamB) {
      throw Exception("Os times A e B não podem ser o mesmo time");
    }
    validateTeamPlayers(teamA);
    validateTeamPlayers(teamB);
  }

  void validateTeamPlayers(Team team) {
    if (team.players.length < 3 || team.players.length > 4) {
      throw Exception("Cada time deve ter entre 3 e 4 jogadores (3 titulares e 1 reserva)");
    }
  }
}

class MatchDurationValidationTest {
  late DateTime startTime;
  late DateTime endTime;

  MatchDurationValidationTest({required this.startTime, required this.endTime}) {
    validateMatchDuration(startTime, endTime);
  }

  void validateMatchDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    if (duration > Duration(minutes: 10)) {
      throw Exception("A partida não pode ultrapassar 10 minutos");
    }
  }
}

class FoulsValidationTest {
  late int fouls;

  FoulsValidationTest({required this.fouls}) {
    validateFouls();
  }

  void validateFouls() {
    if (fouls >= 7) {
      throw Exception("A equipe já atingiu o limite de faltas");
    }
  }
}

class PointsValidationTest {
  late int pointsTeamA;
  late int pointsTeamB;

  PointsValidationTest({required this.pointsTeamA, required this.pointsTeamB}) {
    validatePoints();
  }

  void validatePoints() {
    if (pointsTeamA >= 21 || pointsTeamB >= 21) {
      throw Exception("A partida terminou porque uma equipe alcançou 21 pontos");
    }
  }
}

class MatchStartedValidationTest {
  late bool matchStarted;

  MatchStartedValidationTest({required this.matchStarted}) {
    validateMatchStarted();
  }

  void validateMatchStarted() {
    if (matchStarted) {
      throw Exception("A partida já foi iniciada");
    }
  }
}

class TeamPlayerCountValidationTest {
  late List<Player> players;

  TeamPlayerCountValidationTest({required this.players}) {
    validatePlayerCount();
  }

  void validatePlayerCount() {
    if (players.length < 3 || players.length > 4) {
      throw Exception("Cada time deve ter entre 3 e 4 jogadores (3 titulares e 1 reserva)");
    }
  }
}

class Player {
  late String name;

  Player({required this.name});
}

class Team {
  late String name;
  late List<Player> players;

  Team({required this.name, required this.players}) {
    validTeamName(name);
  }

  void validTeamName(String name) {
    if (name.isEmpty) throw Exception("Nome do Time não pode ser vazio");
  }
}
