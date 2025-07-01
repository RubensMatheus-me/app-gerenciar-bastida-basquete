import 'package:datahoops/app/domain/entities/position.dart';
import 'package:datahoops/app/domain/entities/team.dart';
import 'package:datahoops/app/domain/enums/enum_positions_type.dart';

class Player {
  final dynamic id;
  final String name;
  final int shirtNumber;
  final PositionType position;
  final Team team;

  Player._({
    required this.id,
    required this.name,
    required this.shirtNumber,
    required this.position,
    required this.team,
  });

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'O nome do jogador não pode ser vazio.';
    }
    if (name.trim().length < 2) {
      return 'O nome deve conter pelo menos 2 caracteres.';
    }
    if (RegExp(r'[0-9]').hasMatch(name)) {
      return 'O nome não pode conter números.';
    }
    return null;
  }

  static String? validateShirtNumber(String? shirtNumberStr) {
    if (shirtNumberStr == null || shirtNumberStr.trim().isEmpty) {
      return 'Informe o número da camisa.';
    }
    final number = int.tryParse(shirtNumberStr);
    if (number == null || number <= 0) {
      return 'Número inválido.';
    }
    return null;
  }

  static String? validateTeam(Team? team) {
    if (team == null) {
      return 'O time do jogador não pode ser nulo.';
    }
    return null;
  }

  static String? validatePosition(PositionType? position) {
    if (position == null) {
      return 'A posição do jogador não pode ser vazia.';
    }
    return null;
  }

factory Player({
    required dynamic id,
    required String name,
    required int shirtNumber,
    required PositionType position,
    required Team team,
  }) {
    final nameError = validateName(name);
    if (nameError != null) throw ArgumentError(nameError);

    final shirtNumberError = validateShirtNumber(shirtNumber.toString());
    if (shirtNumberError != null) throw ArgumentError(shirtNumberError);

    final positionError = validatePosition(position);
    if (positionError != null) throw ArgumentError(positionError);

    final teamError = validateTeam(team);
    if (teamError != null) throw ArgumentError(teamError);

    return Player._(
      id: id,
      name: name,
      shirtNumber: shirtNumber,
      position: position,
      team: team,
    );
  }
}