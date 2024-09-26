import 'package:sqflite/sqflite.dart';
import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_match.dart';
import 'package:basketball_statistics/app/domain/interface/dao_match.dart';

class ImpDaoMatch implements IDAOMatch {
  late Database _db;

  @override
  Future<int> insertMatch(DTOMatch match) async {
    _db = await Connection.openDb();
    return await _db.insert('Match', match.toMap());
  }

  @override
  Future<int> updateMatch(DTOMatch match) async {
    _db = await Connection.openDb();
    return await _db.update(
      'Match',
      match.toMap(),
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  @override
  Future<DTOMatch?> getMatchById(int id) async {
    _db = await Connection.openDb();
    List<Map<String, dynamic>> result = await _db.query(
      'Match',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return DTOMatch.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<DTOMatch>> getAllMatches() async {
    _db = await Connection.openDb();
    final List<Map<String, dynamic>> maps = await _db.query('Match');
    return List.generate(maps.length, (i) {
      return DTOMatch.fromMap(maps[i]);
    });
  }

  @override
  Future<List<DTOMatch>> getOngoingMatches() async {
    _db = await Connection.openDb();
    final List<Map<String, dynamic>> maps = await _db.query(
      'Match',
      where: 'isCompleted = 0',
    );
    return List.generate(maps.length, (i) {
      return DTOMatch.fromMap(maps[i]);
    });
  }
}
