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
    db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) {
      createTables.forEach(db.execute);
    });
    dao = ImpDaoTeam();
  });

  test('insert and get team', () async {
    var team = DTOTeam(name: 'Team A');

    await dao.insertTeam(team);

    var teams = await dao.getAllTeams();

    expect(teams.length, 3);
    expect(teams.first.name, 'Team A');
  });
}
