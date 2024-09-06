import 'package:basketball_statistics/app/database/script.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() {
  setUpAll(() {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });
  test('teste script create tables', () async {
    var db = await openDatabase( inMemoryDatabasePath);
    expect(() => createTables.forEach(db.execute), returnsNormally);
  });
}
