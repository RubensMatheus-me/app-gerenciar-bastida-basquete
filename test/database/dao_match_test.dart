import 'package:basketball_statistics/app/database/script.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    sqfliteFfiInit();
  });

  test('teste de criação de tabelas e inserção de Match', () async {
    var db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: (db, version) {
      deleteDatabase(db.path);
      createTables.forEach(db.execute);
    });

    var match = DTOMatch(
      foulsTeamA: 5,
      foulsTeamB: 4,
      pointsTeamA: 21,
      pointsTeamB: 19,
      assists: 8,
      turnovers: 2,
      startTime: DateTime.now(),
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

class DTOMatch {
  final int foulsTeamA;
  final int foulsTeamB;
  final int pointsTeamA;
  final int pointsTeamB;
  final int assists;
  final int turnovers;
  final DateTime startTime;
  final bool isCompleted;

  DTOMatch({
    required this.foulsTeamA,
    required this.foulsTeamB,
    required this.pointsTeamA,
    required this.pointsTeamB,
    required this.assists,
    required this.turnovers,
    required this.startTime,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'foulsTeamA': foulsTeamA,
      'foulsTeamB': foulsTeamB,
      'pointsTeamA': pointsTeamA,
      'pointsTeamB': pointsTeamB,
      'assists': assists,
      'turnovers': turnovers,
      'startTime': startTime.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}