import 'package:datahoops/app/database/sqlite/connection.dart';
import 'package:datahoops/app/domain/dao/dao_player_statistics.dart';
import 'package:datahoops/app/domain/dto/dto_player_statistics_summary.dart';
import 'package:datahoops/app/domain/dto/dto_player_statistics.dart';
import 'package:datahoops/app/domain/dto/dto_player_zone_stats.dart';
import 'package:datahoops/app/domain/entities/assertiveness_pitch.dart';
import 'package:datahoops/app/domain/entities/player.dart';
import 'package:datahoops/app/domain/entities/player_statistics.dart';
import 'package:datahoops/app/domain/entities/team.dart';
import 'package:datahoops/app/domain/entities/match.dart' as app_match;
import 'package:datahoops/app/domain/enums/enum_positions_type.dart';
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';
import 'package:datahoops/app/domain/enums/enum_match_type.dart';
import 'package:sqflite/sqflite.dart';

class ImpDaoPlayerStatistics implements IPlayerStatisticsDao {
  static const String tableName = 'player_statistics';

  @override
  Future<int> insert(PlayerStatisticsDto playerStatistics) async {
    final db = await Connection.openDb();
    return await db.insert(
      tableName,
      playerStatistics.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(PlayerStatisticsDto playerStatistics) async {
    final db = await Connection.openDb();
    return await db.update(
      tableName,
      playerStatistics.toMap(),
      where: 'matchId = ? AND playerId = ?',
      whereArgs: [playerStatistics.matchId, playerStatistics.playerId],
    );
  }

  @override
  Future<int> delete(dynamic id) async {
    final db = await Connection.openDb();
    if (id is Map<String, dynamic>) {
      final matchId = id['matchId'];
      final playerId = id['playerId'];
      return await db.delete(
        tableName,
        where: 'matchId = ? AND playerId = ?',
        whereArgs: [matchId, playerId],
      );
    }
    throw Exception('ID must be a Map<String, dynamic> with matchId and playerId');
  }

  @override
  Future<PlayerStatisticsDto?> getById(dynamic id) async {
    final db = await Connection.openDb();
    if (id is Map<String, dynamic>) {
      final matchId = id['matchId'];
      final playerId = id['playerId'];
      final result = await db.query(
        tableName,
        where: 'matchId = ? AND playerId = ?',
        whereArgs: [matchId, playerId],
        limit: 1,
      );
      if (result.isNotEmpty) {
        return PlayerStatisticsDto.fromMap(result.first);
      }
      return null;
    }
    throw Exception('ID must be a Map<String, dynamic> with matchId and playerId');
  }

  @override
  Future<List<PlayerStatisticsDto>> getAll() async {
    final db = await Connection.openDb();
    final result = await db.query(tableName);
    return result.map((row) => PlayerStatisticsDto.fromMap(row)).toList();
  }

  @override
  Future<int> getTotalPointsByTeam(int teamId, int matchId) async {
    final db = await Connection.openDb();
    final result = await db.rawQuery('''
    SELECT SUM(ps.points) as total
    FROM player_statistics ps
    JOIN player p ON ps.playerId = p.id
    WHERE p.teamId = ? AND ps.matchId = ?
  ''', [teamId, matchId]);

  return result.first['total'] != null ? result.first['total'] as int : 0;
  }
  
Future<List<PlayerStatisticsDto>> getAllByMatchId(int matchId) async {
  final Database db = await Connection.openDb();

  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT ps.points, ps.zonePoint, 
           ps.assertivenessPitchId, ps.matchId, ps.playerId
    FROM player_statistics ps
    WHERE ps.matchId = ?
  ''', [matchId]);

  return result.map((row) {
    return PlayerStatisticsDto(
      points: row['points'],
      zonePoint: row['zonePoint'],
      assertivenessPitchId: row['assertivenessPitchId'],
      matchId: row['matchId'],
      playerId: row['playerId'],
    );
  }).toList();
}

  @override
  Future<List<PlayerStatisticsSummaryDto>> getSummaryByMatchId(int matchId) async {
    final db = await Connection.openDb();

    final result = await db.rawQuery('''
    SELECT 
      p.id as playerId,
      p.name as playerName,
      ps.zonePoint,
      ps.points,
      ap.description as assertiveness
    FROM player_statistics ps
    JOIN player p ON ps.playerId = p.id
    JOIN assertiveness_pitch ap ON ps.assertivenessPitchId = ap.id
    WHERE ps.matchId = ?
  ''', [matchId]);

  final Map<int, PlayerStatisticsSummaryDto> summaryMap = {};

  for (var row in result) {
    final int playerId = row['playerId'] as int;
    final String playerName = row['playerName'] as String;
    final int points = row['points'] as int;
    final String zone = row['zonePoint'] as String;
    final String assertiveness = row['assertiveness'] as String;

    if (!summaryMap.containsKey(playerId)) {
      summaryMap[playerId] = PlayerStatisticsSummaryDto(
        playerId: playerId,
        playerName: playerName,
        totalPoints: 0,
        totalHits: 0,
        totalMisses: 0,
        pointsByZone: {},
      );
    }

    final dto = summaryMap[playerId]!;

    dto.totalPoints += points;
    if (assertiveness.toLowerCase().contains('erro')) {
      dto.totalMisses += 1;
    } else {
      dto.totalHits += 1;
    }

    dto.pointsByZone.update(zone, (value) => value + points, ifAbsent: () => points);
  }

  return summaryMap.values.toList();
}

  @override
  Future<List<PlayerZoneStatsDto>> getZoneSummaryByMatchId(int matchId) async {
    final db = await Connection.openDb();

  final result = await db.rawQuery('''
    SELECT 
      ps.playerId,
      p.name AS playerName,
      ps.zonePoint,
      ps.assertivenessPitchId,
      COUNT(*) AS totalAttempts,
      SUM(ps.points) AS totalPoints
    FROM player_statistics ps
    JOIN player p ON ps.playerId = p.id
    WHERE ps.matchId = ?
    GROUP BY ps.playerId, ps.zonePoint, ps.assertivenessPitchId
    ORDER BY p.name;
  ''', [matchId]);

  return result.map((row) => PlayerZoneStatsDto(
    playerId: row['playerId'] as int,
    playerName: row['playerName'] as String,
    zonePoint: row['zonePoint'] as String,
    assertivenessPitchId: row['assertivenessPitchId'] as int,
    totalAttempts: row['totalAttempts'] as int,
    totalPoints: row['totalPoints'] as int? ?? 0,
  )).toList();
  }
  
  @override
  Future<int> getTotalErrorsByMatch(int matchId) async {
    final db = await Connection.openDb();

    final result = await db.rawQuery('''
      SELECT COUNT(*) as totalErrors
      FROM player_statistics
      WHERE matchId = ? AND assertivenessPitchId = 2
    ''', [matchId]);

    if (result.isEmpty || result.first['totalErrors'] == null) return 0;

    return (result.first['totalErrors'] as int);
  }
  
  @override
  Future<int> getTotalPointsByMatch(int matchId) async {
    final db = await Connection.openDb();

    final result = await db.rawQuery('''
      SELECT SUM(points) as totalPoints
      FROM player_statistics
      WHERE matchId = ?
    ''', [matchId]);

    if (result.isEmpty || result.first['totalPoints'] == null) return 0;

    return (result.first['totalPoints'] as int);
  }

  @override
  Future<int> getTotalErrorsByPlayer(int playerId, int matchId) async {
    final db = await Connection.openDb();
    final result = await db.rawQuery('''
      SELECT COUNT(*) AS totalErrors
      FROM player_statistics
      WHERE matchId = ? AND playerId = ? AND assertivenessPitchId = 2
    ''', [matchId, playerId]);
    return result.first['totalErrors'] != null ? result.first['totalErrors'] as int : 0;
  }

  @override
  Future<int> getTotalPointsByPlayer(int playerId, int matchId) async {
    final db = await Connection.openDb();
    final result = await db.rawQuery('''
      SELECT SUM(points) AS totalPoints
      FROM player_statistics
      WHERE matchId = ? AND playerId = ?
    ''', [matchId, playerId]);
    return result.first['totalPoints'] != null ? result.first['totalPoints'] as int : 0;
  }

}
