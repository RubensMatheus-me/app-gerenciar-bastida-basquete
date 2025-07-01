import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dto/dto_pitches.dart';
import 'package:datahoops/app/domain/dao/dao_pitches.dart';

import 'package:sqflite/sqflite.dart';

class ImpDaoPitches implements IPitchesDao {
  static const String tableName = 'pitches';

  @override
  Future<int> insert(PitchesDto pitches) async {
    final db = await Connection.openDb();
    return await db.insert(
      tableName,
      pitches.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(PitchesDto pitches) async {
    final db = await Connection.openDb();
    return await db.update(
      tableName,
      pitches.toMap(),
      where: 'id = ?',
      whereArgs: [pitches.id],
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
  Future<PitchesDto?> getById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return PitchesDto.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<PitchesDto>> getAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((map) => PitchesDto.fromMap(map)).toList();
  }
}
