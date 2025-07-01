import 'package:sqflite/sqflite.dart';
import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dto/dto_match.dart';
import 'package:datahoops/app/domain/dao/dao_match.dart';

class ImpDaoMatch implements IMatchDao {
  static const String tableName = 'match';

  @override
  Future<int> insert(MatchDto match) async {
    final db = await Connection.openDb();
    return await db.insert(
      tableName,
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<MatchDto>> getAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((row) => MatchDto.fromMap(row)).toList();
  }

  @override
  Future<MatchDto?> getById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return MatchDto.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int> update(MatchDto match) async {
    final db = await Connection.openDb();
    return await db.update(
      tableName,
      match.toMap(),
      where: 'id = ?',
      whereArgs: [match.id],
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
}
