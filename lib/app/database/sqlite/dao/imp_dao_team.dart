import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/interface/dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoTeam implements IDAOTeam {
  late Database _db;

  @override
  Future<int> insertTeam(DTOTeam team) async {
    _db = await Connection.openDb();
    return await _db.insert('Team', team.toMap());
  }

  @override
  Future<int> updateTeam(DTOTeam team) async {
    _db = await Connection.openDb();
    return await _db.update(
      'Team',
      team.toMap(),
      where: 'id = ?',
      whereArgs: [team.id],
    );
  }

  @override
  Future<int> deleteTeam(dynamic id) async {
    _db = await Connection.openDb();
    return await _db.delete(
      'Team',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DTOTeam?> getTeamById(dynamic id) async {
    _db = await Connection.openDb();
    List<Map<String, dynamic>> maps = await _db.query(
      'Team',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DTOTeam.fromMap(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<DTOTeam>> getAllTeams() async {
    _db = await Connection.openDb();
    final List<Map<String, dynamic>> maps = await _db.query('Team');
    return List.generate(maps.length, (i) {
      return DTOTeam.fromMap(maps[i]);
    });
  }

  Future<List<DTOPlayer>> getPlayersForTeam(int teamId) async {
    _db = await Connection.openDb();
    final List<Map<String, dynamic>> maps = await _db.query(
      'Player',
      where: 'teamId = ?',
      whereArgs: [teamId],
    );
    return List.generate(maps.length, (i) {
      return DTOPlayer.fromMap(maps[i]);
    });
  }
}
