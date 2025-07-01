import 'package:datahoops/app/domain/entities/team.dart';

class TeamDto {
  final dynamic id;
  final String name;

  TeamDto({
    required this.id,
    required this.name,
  });

  factory TeamDto.fromMap(Map<String, dynamic> map) {
    return TeamDto(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Team toEntity() {
    return Team(
      id: id,
      name: name,
    );
  }

  factory TeamDto.fromEntity(Team team) {
    return TeamDto(
      id: team.id,
      name: team.name,
    );
  }
}
