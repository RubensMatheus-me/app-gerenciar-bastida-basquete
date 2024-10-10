import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';
import 'package:basketball_statistics/app/domain/interface/dao_afterMatch.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoAfterMatch implements IDaoAftermatch {
  late Database _db;

  ImpDaoAfterMatch(this._db);

  @override
  Future<DTOAfterMatch> getMatchStatistics(int matchId) async {
    _db = await Connection.openDb();

    final List<Map<String, dynamic>> result = await _db.rawQuery('''
      SELECT 
        Match.id as id,
        (Match.pointsTeamA + Match.pointsTeamB) as totalPoints,
        Match.timer as durationMatch,
        (Match.foulsTeamA + Match.foulsTeamB) as totalFouls,
        CASE 
          WHEN Match.pointsTeamA > Match.pointsTeamB THEN TeamA.name
          ELSE TeamB.name
        END as winner,
        ABS(Match.pointsTeamA - Match.pointsTeamB) as pointsDifference,
        SUM(Player.rebounds) as totalRebounds,
        SUM(Player.assists) as totalAssists
      FROM Match
      INNER JOIN Team AS TeamA ON Match.teamAId = TeamA.id
      INNER JOIN Team AS TeamB ON Match.teamBId = TeamB.id
      INNER JOIN Player ON (Player.teamId = TeamA.id OR Player.teamId = TeamB.id)
      WHERE Match.id = ?
      GROUP BY Match.id
    ''', [matchId]);

    if (result.isNotEmpty) {
      return DTOAfterMatch.fromMap(result.first);
    } else {
      throw Exception("Estatísticas da partida não encontradas");
    }
  }
}
