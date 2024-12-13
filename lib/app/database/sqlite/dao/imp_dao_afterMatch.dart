import 'package:basketball_statistics/app/database/sqlite/connection.dart';
import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_afterMatch.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoAfterMatch implements IDaoAftermatch {
  late Database _db;
@override
Future<DTOAfterMatch> getMatchStatistics(int matchId) async {
  _db = await Connection.openDb();

  final List<Map<String, dynamic>> matchResult = await _db.rawQuery('''
    SELECT 
  Match.id AS id,
  (Match.pointsTeamA + Match.pointsTeamB) AS totalPoints,
  Match.timer AS durationMatch,
  (Match.foulsTeamA + Match.foulsTeamB) AS totalFouls,
  Match.pointsTeamA, -- Include this
  Match.pointsTeamB, -- Include this
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

  if (matchResult.isEmpty) {
    throw Exception("Estatísticas da partida não encontradas");
  }

  final List<Map<String, dynamic>> playerStatsResult = await _db.rawQuery('''
    SELECT 
      Player.id AS id,
   Player.name AS name,
   Player.position AS position,
   Player.tShirtNumber AS tShirtNumber,
   Player.teamId AS teamId,
   PlayerMatchStats.rebounds AS rebounds,
   PlayerMatchStats.assists AS assists,
   PlayerMatchStats.points AS points
FROM PlayerMatchStats
INNER JOIN Player ON PlayerMatchStats.playerId = Player.id
WHERE PlayerMatchStats.matchId = ?
  ''', [matchId]);

  final List<DTOPlayer> players = playerStatsResult.map((map) => DTOPlayer.fromMap(map)).toList();


  return DTOAfterMatch.fromMap(matchResult.first, players);
}
}