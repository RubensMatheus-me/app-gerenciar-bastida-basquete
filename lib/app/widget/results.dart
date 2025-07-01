import 'package:datahoops/app/database/sqlite/dao/imp_dao_player_statistics.dart';
import 'package:datahoops/app/domain/dto/dto_player_statistics_summary.dart';
import 'package:datahoops/app/domain/dto/dto_player_zone_stats.dart';
import 'package:datahoops/app/domain/dto/dto_player.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:datahoops/app/domain/entities/match.dart' as app_match;
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';
import 'package:datahoops/app/widget/utils/group_by.dart';
import 'package:datahoops/app/widget/utils/zone_stats_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final app_match.Match match;
  final String winnerTeam;
  final int matchId;
  final List<TeamDto> teams;          
  final Map<int, List<PlayerDto>> playersByTeam;

  const Results({
    Key? key,
    required this.match,
    required this.winnerTeam,
    required this.matchId,
    required this.teams,
    required this.playersByTeam,
  }) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late Future<List<PlayerStatisticsSummaryDto>> _playerResultsFuture;
  List<PlayerZoneStatsDto> _zoneStats = [];
  int totalPoints = 0;
  int totalErrors = 0;

  @override
  void initState() {
    super.initState();
    _loadPlayerResults();
    _loadZoneStats();
    _loadTotals();
  }

  Future<void> _loadZoneStats() async {
    final statsDao = ImpDaoPlayerStatistics();
    final zoneStats = await statsDao.getZoneSummaryByMatchId(widget.matchId);

    setState(() {
      _zoneStats = zoneStats;
    });
  }

  Future<void> _loadTotals() async {
    final statsDao = ImpDaoPlayerStatistics();

    final pointsResult = await statsDao.getTotalPointsByMatch(widget.matchId);
    final errorsResult = await statsDao.getTotalErrorsByMatch(widget.matchId);

    setState(() {
      totalPoints = pointsResult ?? 0;
      totalErrors = errorsResult ?? 0;
    });
  }

  void _loadPlayerResults() {
    final dao = ImpDaoPlayerStatistics();
    _playerResultsFuture = dao.getSummaryByMatchId(widget.matchId);
  }

  Widget _buildSummaryChart() {
    final data = [
      _ChartData('Pontos', totalPoints.toDouble(), Colors.green),
      _ChartData('Erros', totalErrors.toDouble(), Colors.red),
    ];

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (totalPoints > totalErrors ? totalPoints : totalErrors) * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 1),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index].label,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            int idx = entry.key;
            _ChartData d = entry.value;
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: d.value,
                  color: d.color,
                  width: 30,
                  borderRadius: BorderRadius.circular(6),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTeamPlayersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.teams.map((team) {
        final players = widget.playersByTeam[team.id] ?? [];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 3,
            child: ExpansionTile(
              title: Text(team.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              children: players.map((player) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(player.name),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Partida'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Vencedor: ${widget.winnerTeam}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            const Text(
              'Resumo Geral da Partida',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            _buildSummaryChart(),
            const SizedBox(height: 24),

            const Text(
              'Times e Jogadores',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            _buildTeamPlayersList(),
            const SizedBox(height: 24),

            const Text(
              'Estatísticas Detalhadas por Jogador',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            _zoneStats.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: _zoneStats
                        .groupListsBy((e) => e.playerName)
                        .entries
                        .map((entry) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey[800],
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              ZoneStatsChart(stats: entry.value),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final double value;
  final Color color;

  _ChartData(this.label, this.value, this.color);
}
