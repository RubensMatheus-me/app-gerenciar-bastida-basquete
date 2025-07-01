import 'package:datahoops/app/domain/enums/enum_positions_type.dart';
import 'package:datahoops/app/domain/entities/player.dart';
import 'package:datahoops/app/domain/entities/team.dart';

class PlayerDto {
  final dynamic id;
  final String name;
  final int shirtNumber;
  final dynamic teamId;
  final String position;

  PlayerDto({
    required this.id,
    required this.name,
    required this.shirtNumber,
    required this.teamId,
    required this.position,
  });

  factory PlayerDto.fromMap(Map<String, dynamic> map) {
    return PlayerDto(
      id: map['id'],
      name: map['name'],
      shirtNumber: map['shirtNumber'],
      teamId: map['teamId'],
      position: map['position'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shirtNumber': shirtNumber,
      'teamId': teamId,
      'position': position,
    };
  }

  Player toEntity(Team team) {
    return Player(
      id: id,
      name: name,
      shirtNumber: shirtNumber,
      team: team,
      position: _positionTypeFromString(position),
    );
  }

  factory PlayerDto.fromEntity(Player player) {
    return PlayerDto(
      id: player.id,
      name: player.name,
      shirtNumber: player.shirtNumber,
      teamId: player.team.id,
      position: player.position.name, 
    );
  }

  static PositionType _positionTypeFromString(String positionStr) {
    return PositionType.values.firstWhere(
      (e) => e.name.toLowerCase() == positionStr.toLowerCase(),
      orElse: () => throw ArgumentError('Posição inválida: $positionStr'),
    );
  }
}
