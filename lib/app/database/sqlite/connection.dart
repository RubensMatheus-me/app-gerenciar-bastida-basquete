import 'package:basketball_statistics/app/database/script.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Connection {
  static late Database _db;
  static bool isOpened = false;

  static Future<Database> openDb() async {
    if (!isOpened) {
      var path = join(await getDatabasesPath(), 'basketball.db');

      await deleteDatabase(path);

      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          for (var table in createTables) {
            await db.execute(table);
          }
          for (var register in insertRegisters) {
            await db.execute(register);
          }
          await db.execute('PRAGMA foreign_keys=ON');
        },
      );

      isOpened = true;
    }
    return _db;
  }
}
