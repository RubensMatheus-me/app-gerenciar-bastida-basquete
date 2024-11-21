import 'package:basketball_statistics/app/database/script.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_afterMatch.dart';
import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  test('Deve retornar estatísticas de uma partida com sucesso', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) {
      createTables.forEach(db.execute);
      insertRegisters.forEach(db.execute);
    });

    final dao = ImpDaoAfterMatch(db);

    const matchId = 1;

    final DTOAfterMatch afterMatch = await dao.getMatchStatistics(matchId);

    expect(afterMatch.totalPoints, greaterThan(0));
    expect(afterMatch.totalAssists, greaterThan(0));
    expect(afterMatch.winner, isNotEmpty);
  });
}
