import 'package:datahoops/app/domain/entities/player.dart';

class Team {
  final dynamic id;
  final String name;

  Team._({
    required this.id,
    required this.name,
  });

  factory Team({
    required dynamic id,
    required String name,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('O nome do time não pode ser vazio.');
    }
    if (name.length < 2) {
      throw ArgumentError('O nome do time deve conter pelo menos 2 caracteres.');
    }

    return Team._(
      id: id,
      name: name,
    );
  }

  void validateMinimumPlayers(List<Player> players) {
    final teamPlayers = players.where((p) => p.team.id == id).toList();
    if (teamPlayers.length < 3) {
      throw Exception('O time "$name" deve ter pelo menos 3 jogadores.');
    }
  }
}
