import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dto/dto_distance.dart';
import 'package:datahoops/app/domain/dao/dao_distance.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoDistance implements IDistanceDAO {
  static const String tableName = 'distance';

  @override
  Future<void> save(DistanceDTO distance) async {
    final db = await Connection.openDb();
    await db.insert(
      tableName,
      {
        'id': distance.id,
        'distance': distance.distance,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
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
  Future<List<DistanceDTO>> findAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((row) => DistanceDTO(
      id: row['id'],
      distance: row['distance'] as String,
    )).toList();
  }

  @override
  Future<DistanceDTO?> findById(dynamic id) async {
    final db = await Connection.openDb();
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      final row = result.first;
      return DistanceDTO(
        id: row['id'],
        distance: row['distance'] as String,
      );
    }
    return null;
  }
}
