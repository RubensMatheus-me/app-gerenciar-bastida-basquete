import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dao/dao_type_match.dart';
import 'package:datahoops/app/domain/dto/dto_type_match.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoTypeMatch implements ITypeMatchDao {
  static const String tableName = 'type_match';

  @override
  Future<void> save(TypeMatchDto dto) async {
    final db = await Connection.openDb();

    if (dto.id == null) {
      await db.insert(
        tableName,
        dto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        tableName,
        dto.toMap(),
        where: 'id = ?',
        whereArgs: [dto.id],
      );
    }
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
  Future<List<TypeMatchDto>> findAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((row) => TypeMatchDto.fromMap(row)).toList();
  }

  @override
  Future<TypeMatchDto?> findById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return TypeMatchDto.fromMap(result.first);
    }
    return null;
  }
}
