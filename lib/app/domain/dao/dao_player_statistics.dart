import 'package:datahoops/app/domain/dto/dto_player_statistics_summary.dart';
import 'package:datahoops/app/domain/dto/dto_player_statistics.dart';
import 'package:datahoops/app/domain/dto/dto_player_zone_stats.dart';

abstract class IPlayerStatisticsDao {
  Future<int> insert(PlayerStatisticsDto playerStatistics);
  Future<int> update(PlayerStatisticsDto playerStatistics);
  Future<int> delete(dynamic id);
  Future<PlayerStatisticsDto?> getById(dynamic id);
  Future<List<PlayerStatisticsDto>> getAll();
  Future<int> getTotalPointsByTeam(int teamId, int matchId);
  Future<List<PlayerStatisticsDto>> getAllByMatchId(int matchId);
  Future<List<PlayerStatisticsSummaryDto>> getSummaryByMatchId(int matchId);
  Future<List<PlayerZoneStatsDto>> getZoneSummaryByMatchId(int matchId);
  Future<int> getTotalErrorsByMatch(int matchId);
  Future<int> getTotalPointsByMatch(int matchId);
}
