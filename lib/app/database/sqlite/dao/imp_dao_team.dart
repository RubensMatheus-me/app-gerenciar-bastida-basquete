import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:basketball_statistics/app/domain/interface/dao_team.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoTeam implements IDAOTeam {
  late Database _db;

  @override
  save(DTOTeam dto) async {
    _db = await Connection.openDb();

    int id = await _db
        .rawInsert('''INSERT INTO team (name, player)
      VALUES (?, ?, ?, ?) 
      ''', [dto.name, dto.players]);

    dto.id = id;
    return dto;
  }

  @override
  Future<List<Team>> search() async {
    _db = await Connection.openDb();

    List<Map<String, dynamic>> result = await _db.query('player');

    List<Team> list = List.generate(result.length, (i) {
      var line = result[i];
      return Team(
        id: line['id'],
        name: line['name'],
        players: line['player'],
      );
    });
    return list;
  }
}
