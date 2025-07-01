import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dto/dto_player.dart';
import 'package:datahoops/app/domain/dao/dao_player.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoPlayer implements IPlayerDao {
  static const String tableName = 'player';

  @override
  Future<int> insert(PlayerDto player) async {
    final db = await Connection.openDb();
    return await db.insert(
      tableName,
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(PlayerDto player) async {
    final db = await Connection.openDb();
    return await db.update(
      tableName,
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }

  @override
  Future<int> delete(dynamic id) async {
    final db = await Connection.openDb();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<PlayerDto?> findById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return PlayerDto.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<PlayerDto>> findAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((map) => PlayerDto.fromMap(map)).toList();
  }
  
  @override
  Future<List<PlayerDto>> getPlayerByTeam(dynamic teamId) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'teamId = ?',
      whereArgs: [teamId],
    );
  
    return List.generate(result.length, (i) {
      return PlayerDto.fromMap(result[i]);
    });
  }

}
