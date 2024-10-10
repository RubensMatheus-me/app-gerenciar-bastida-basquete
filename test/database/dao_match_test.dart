import 'package:basketball_statistics/app/database/script.dart';
import 'package:basketball_statistics/app/domain/dto/dto_match.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  test('teste de criação de tabelas e inserção de Match', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) {
      deleteDatabase(db.path);
      createTables.forEach(db.execute);
    });

    var match = DTOMatch(
      teamAId: 1, 
      teamBId: 2, 
      foulsTeamA: 5,
      foulsTeamB: 4,
      pointsTeamA: 21,
      pointsTeamB: 19,
      assists: 8,
      turnGame: 4,
      timer: 600,
      isCompleted: true,
    );

    await db.insert('Match', match.toMap());

    var list = await db.rawQuery('SELECT * FROM Match');
    expect(list.length, 1);
    expect(list.first['foulsTeamA'], match.foulsTeamA);
    expect(list.first['pointsTeamA'], match.pointsTeamA);
    expect(list.first['isCompleted'], match.isCompleted ? 1 : 0);
  });
}
