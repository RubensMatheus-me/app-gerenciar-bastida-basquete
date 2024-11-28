import 'package:sqflite/sqflite.dart';
import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_match.dart';
import 'package:basketball_statistics/app/domain/interface/dao_match.dart';

class ImpDaoMatch implements IDAOMatch {
  late Database _db;

  // Ensure the database is initialized
  Future<void> _initializeDb() async {
    _db = await Connection.openDb();
  }

  @override
  Future<int> insertMatch(DTOMatch match) async {
    await _initializeDb();  // Ensure _db is initialized
    return await _db.insert('Match', match.toMap());
  }

  @override
  Future<int> updateMatch(DTOMatch match) async {
    await _initializeDb();  // Ensure _db is initialized
    return await _db.update(
      'Match',
      match.toMap(),
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  @override
  Future<DTOMatch?> getMatchById(int id) async {
    await _initializeDb();  // Ensure _db is initialized
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
    await _initializeDb();  // Ensure _db is initialized
    final List<Map<String, dynamic>> maps = await _db.query('Match');
    return List.generate(maps.length, (i) {
      return DTOMatch.fromMap(maps[i]);
    });
  }

  Future<DTOMatch?> getMatchForTeams(int teamAId, int teamBId) async {
    await _initializeDb();  // Ensure _db is initialized
    final result = await _db.query(
      'Match',  // Correct table name
      where: 'teamAId = ? AND teamBId = ?',
      whereArgs: [teamAId, teamBId],
    );

    if (result.isNotEmpty) {
      return DTOMatch.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<DTOMatch>> getOngoingMatches() async {
    await _initializeDb();  // Ensure _db is initialized
    final List<Map<String, dynamic>> maps = await _db.query(
      'Match',
      where: 'isCompleted = 0',
    );
    return List.generate(maps.length, (i) {
      return DTOMatch.fromMap(maps[i]);
    });
  }

  @override
  Future<int> updateMatchPoints(int matchId, int pointsTeamA, int pointsTeamB) async {
  final db = await Connection.openDb();

  return await db.update(
    'Match',
    {
      'pointsTeamA': pointsTeamA,
      'pointsTeamB': pointsTeamB,
    },
    where: 'id = ?',
    whereArgs: [matchId],
  );
  }
}
