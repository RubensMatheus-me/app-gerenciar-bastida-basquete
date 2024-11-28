import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';
import 'package:basketball_statistics/app/domain/interface/dao_afterMatch.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoAfterMatch implements IDaoAftermatch {
  late Database _db;


  @override
  Future<DTOAfterMatch> getMatchStatistics(int matchId) async {
    _db = await Connection.openDb();

    final List<Map<String, dynamic>> result = await _db.rawQuery('''
    SELECT 
      Match.id AS id,
      (Match.pointsTeamA + Match.pointsTeamB) AS totalPoints,
      Match.timer AS durationMatch,
      (Match.foulsTeamA + Match.foulsTeamB) AS totalFouls,
      CASE 
        WHEN Match.pointsTeamA > Match.pointsTeamB THEN TeamA.name
        ELSE TeamB.name
      END AS winner,
      ABS(Match.pointsTeamA - Match.pointsTeamB) AS pointsDifference,
      (SELECT SUM(PlayerMatchStats.rebounds) 
      FROM PlayerMatchStats 
      WHERE PlayerMatchStats.matchId = Match.id) AS totalRebounds,
      (SELECT SUM(PlayerMatchStats.assists) 
      FROM PlayerMatchStats 
      WHERE PlayerMatchStats.matchId = Match.id) AS totalAssists
    FROM Match
    INNER JOIN Team AS TeamA ON Match.teamAId = TeamA.id
    INNER JOIN Team AS TeamB ON Match.teamBId = TeamB.id
    WHERE Match.id = ?
  ''', [matchId]);

    if (result.isNotEmpty) {
      return DTOAfterMatch.fromMap(result.first);
    } else {
      throw Exception("Estatísticas da partida não encontradas");
    }
  }
}
