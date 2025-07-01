import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dao/dao_assertiveness_pitch.dart';
import 'package:datahoops/app/domain/dto/dto_assertiveness_pitch.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoAssertivenessPitch implements IAssertivenessPitchDAO {
  static const String tableName = 'assertiveness_pitch';

  @override
  Future<void> insert(AssertivenessPitchDTO pitch) async {
    final db = await Connection.openDb();
    await db.insert(
      tableName,
      pitch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(AssertivenessPitchDTO pitch) async {
    final db = await Connection.openDb();
    await db.update(
      tableName,
      pitch.toMap(),
      where: 'id = ?',
      whereArgs: [pitch.id],
    );
  }

  @override
  Future<void> delete(dynamic id) async {
    final db = await Connection.openDb();
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<AssertivenessPitchDTO?> getById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return AssertivenessPitchDTO.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<AssertivenessPitchDTO>> getAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((map) => AssertivenessPitchDTO.fromMap(map)).toList();
  }
}
