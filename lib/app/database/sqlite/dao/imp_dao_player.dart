import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoPlayer implements IDAOPlayer {
  late Database _db;


  @override
  Future<int> insertPlayer(DTOPlayer player) async {
    _db = await Connection.openDb();
    return await _db.insert('Player', player.toMap());
  }

  @override
  Future<List<DTOPlayer>> getPlayersByTeam(dynamic teamId) async {
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
  @override
  Future<int> updatePlayer(DTOPlayer player) async {
    _db = await Connection.openDb();
    return await _db.update(
      'Player',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }
  @override
  Future<int> deletePlayer(dynamic id) async {
    _db = await Connection.openDb();
    return await _db.delete(
      'Player',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> updatePlayerMatchStats(
  int playerId,
  int matchId, {
  int? points,
  int? rebounds,
  int? assists,
}) async {
  final db = await Connection.openDb();

  final statsToUpdate = <String, dynamic>{};
  if (points != null) statsToUpdate['points'] = points;
  if (rebounds != null) statsToUpdate['rebounds'] = rebounds;
  if (assists != null) statsToUpdate['assists'] = assists;

  return await db.update(
    'PlayerMatchStats',
    statsToUpdate,
    where: 'playerId = ? AND matchId = ?',
    whereArgs: [playerId, matchId],
  );
}
}

