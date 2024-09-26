import 'package:basketball_statistics/app/database/script.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() {
  late Database db;
  late ImpDaoTeam dao;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
    db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: (db, version) {
      createTables.forEach(db.execute);
    });
    dao = ImpDaoTeam(db);
  });

  test('insert and get team', () async {
    var team = DTOTeam(id: 1, name: 'Team A');
    await dao.insertTeam(team);

    var result = await dao.getTeamById(1);

    expect(result?.name, 'Team A');
  });

  tearDownAll(() async {
    await db.close();
  });
}
