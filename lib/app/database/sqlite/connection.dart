import 'package:basketball_statistics/app/database/script.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Connection {
  static late Database _db;
  static bool isOpened = false;

  static Future<Database> openDb() async {
    if (!isOpened) {
      var path = join(await getDatabasesPath(), 'basketball.db');
      
      _db = await openDatabase(path, version: 1, onCreate: (db, version) {
        createTables.forEach(db.execute);
        insertRegisters.forEach(db.execute);
      });
      isOpened = true;

    }
    return _db;
  }
}
