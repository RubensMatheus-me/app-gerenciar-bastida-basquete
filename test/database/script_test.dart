import 'package:basketball_statistics/app/database/script.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() {
  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });
  test('teste script create tables', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) {
      deleteDatabase(db.path);
      createTables.forEach(db.execute);
      insertRegisters.forEach(db.execute);
    });
    var list = await db.rawQuery('SELECT * FROM Player');
    expect(list.length, 4); // 4 players no banco
  });
}
