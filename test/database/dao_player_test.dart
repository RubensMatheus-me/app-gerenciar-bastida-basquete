import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/entities/player.dart';
import 'package:basketball_statistics/app/domain/entities/team.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ImpDaoPlayer daoPlayer;

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();

    db = await Connection.openDb();
    daoPlayer = ImpDaoPlayer(db);

    // Optionally, clean up the database to start with a fresh state for each test
    await db.execute('DROP TABLE IF EXISTS player');
    await db.execute('''
      CREATE TABLE player (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        position TEXT,
        tShirtNumber INTEGER,
        team TEXT
      )
    ''');
  });

  tearDownAll(() async {
    await db.close();
  });

  test('save and search player', () async {
    var player = DTOPlayer(
      name: 'John Doe',
      position: 'Guard',
      tShirtNumber: 23,
      association: DTOTeam(name: 'TeamA', players: [], id: 1),
    );

    try {
      var savedPlayer = await daoPlayer.save(player);
      expect(savedPlayer.id, isNotNull, reason: 'Player ID should not be null');

      var players = await daoPlayer.search();
      expect(players.length, 1,
          reason: 'There should be exactly one player in the database');
      expect(players.first.name, 'John Doe',
          reason: 'Player name does not match');
      expect(players.first.position, 'Guard',
          reason: 'Player position does not match');
      expect(players.first.tShirtNumber, 23,
          reason: 'Player T-shirt number does not match');
      expect(players.first.association, 'TeamA',
          reason: 'Player team does not match');

      print('save and search player returns normally');
    } catch (e) {
      print('save and search player resulted in ErrorException: $e');
      rethrow;
    }
  });

  test('remove player', () async {
    var player = DTOPlayer(
      name: 'Jane Doe',
      position: 'Forward',
      tShirtNumber: 24,
      association: DTOTeam(name: 'TeamA', players: [], id: 1),
    );

    try {
      var savedPlayer = await daoPlayer.save(player);
      expect(savedPlayer.id, isNotNull, reason: 'o player nao pode ser nulo');

      await daoPlayer.remove(savedPlayer.id);

      var players = await daoPlayer.search();
      expect(players.isEmpty, true,
          reason: 'Player list should be empty after removal');

      print('remove player returns normally');
    } catch (e) {
      print('remove player resulted in ErrorException: $e');
      rethrow; // Re-throw to ensure the test framework captures the error
    }
  });
}
