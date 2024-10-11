import 'package:basketball_statistics/app/database/script.dart';
import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();

    db = await Connection.openDb();

    for (var register in insertRegisters) {
      await db.execute(register);
    }
  });

  tearDownAll(() async {
    await db.execute('DELETE FROM Player');
    await db.execute('DELETE FROM Team');
    await db.execute('DELETE FROM Match');
    await db.execute('DELETE FROM AfterMatch');
    await db.close();
  });

  test('test create connection', () async {
    var list = await db.rawQuery('SELECT * FROM Player');
    expect(list.length,
        4);
  });
}
