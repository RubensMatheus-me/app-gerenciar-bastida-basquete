import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dao/dao_team.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';

import 'package:sqflite/sqflite.dart';

class ImpDaoTeam implements ITeamDao {
  static const String tableName = 'team';

  @override
  Future<int> insert(TeamDto team) async {
    final db = await Connection.openDb();
    return await db.insert(
      tableName,
      team.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(TeamDto team) async {
    final db = await Connection.openDb();
    return await db.update(
      tableName,
      team.toMap(),
      where: 'id = ?',
      whereArgs: [team.id],
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
  Future<TeamDto?> getById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return TeamDto.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<TeamDto>> getAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((row) => TeamDto.fromMap(row)).toList();
  }
}
