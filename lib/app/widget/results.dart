import 'package:datahoops/app/database/sqlite/dao/imp_dao_player_statistics.dart';
import 'package:datahoops/app/domain/dto/dto_player_statistics_summary.dart';
import 'package:datahoops/app/domain/dto/dto_player_zone_stats.dart';
import 'package:datahoops/app/domain/dto/dto_player.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:datahoops/app/domain/entities/match.dart' as app_match;
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

class _ResultsState extends State<Results> with TickerProviderStateMixin {
  late Future<List<PlayerStatisticsSummaryDto>> _playerResultsFuture;
  List<PlayerZoneStatsDto> _zoneStats = [];

  int totalPoints = 0;
  int totalErrors = 0;
  double _totalEfficiency = 0.0;

  Map<int, int> _pointsByTeam = {};
  Map<int, int> _errorsByTeam = {};
  Map<int, double> _efficiencyByTeam = {};

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

    Map<int, int> pointsByTeam = {};
    Map<int, int> errorsByTeam = {};
    Map<int, double> efficiencyByTeam = {};

    for (var team in widget.teams) {
      final teamPlayers = widget.playersByTeam[team.id] ?? [];
      int teamPoints = 0;
      int teamErrors = 0;

      for (var player in teamPlayers) {
        final playerPoints = await statsDao.getTotalPointsByPlayer(
          player.id,
          widget.matchId,
        );
        final playerErrors = await statsDao.getTotalErrorsByPlayer(
          player.id,
          widget.matchId,
        );

        teamPoints += playerPoints;
        teamErrors += playerErrors;
      }

      pointsByTeam[team.id] = teamPoints;
      errorsByTeam[team.id] = teamErrors;
      efficiencyByTeam[team.id] = (teamPoints + teamErrors) > 0
          ? teamPoints / (teamPoints + teamErrors) * 100
          : 0.0;
    }

    int totalPoints = pointsByTeam.values.fold(0, (a, b) => a + b);
    int totalErrors = errorsByTeam.values.fold(0, (a, b) => a + b);
    double totalEfficiency = (totalPoints + totalErrors) > 0
        ? totalPoints / (totalPoints + totalErrors) * 100
        : 0.0;

    setState(() {
      this.totalPoints = totalPoints;
      this.totalErrors = totalErrors;
      this._pointsByTeam = pointsByTeam;
      this._errorsByTeam = errorsByTeam;
      this._efficiencyByTeam = efficiencyByTeam;
      this._totalEfficiency = totalEfficiency;
    });
  }

  void _loadPlayerResults() {
    final dao = ImpDaoPlayerStatistics();
    _playerResultsFuture = dao.getSummaryByMatchId(widget.matchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Partida'),
        backgroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(text: 'Resumo'),
            Tab(text: 'Times & Zona'),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: TabBarView(
        controller: _tabController,
        children: [_buildSummaryTab(), _buildTeamsAndZoneStats()],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return Padding(
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
          const SizedBox(height: 16),
          const Text(
            'Resumo Geral da Partida',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildSummaryChart(),
          const SizedBox(height: 8),
          Text(
            'Aproveitamento total: ${_totalEfficiency.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Desempenho dos Jogadores',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<PlayerStatisticsSummaryDto>>(
            future: _playerResultsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              return _buildPlayerPerformanceChart(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsAndZoneStats() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.teams.map((team) {
          final players = widget.playersByTeam[team.id] ?? [];
          final points = _pointsByTeam[team.id] ?? 0;
          final errors = _errorsByTeam[team.id] ?? 0;
          final efficiency = _efficiencyByTeam[team.id] ?? 0.0;

          double maxY = (points + errors) * 1.2;
          double interval = 5;
          while ((maxY / interval) > 5) {
            interval += 5;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[800],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.center,
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                rodIndex == 0
                                    ? 'Pontos: ${points}'
                                    : 'Erros: ${errors}',
                                TextStyle(
                                  color: rodIndex == 0
                                      ? Colors.green
                                      : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: interval,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Column(
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'Acertos/Erros',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Aproveitamento: ${efficiency.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              reservedSize: 50,
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: points.toDouble(),
                                color: Colors.green,
                                width: 18,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              BarChartRodData(
                                toY: errors.toDouble(),
                                color: Colors.redAccent,
                                width: 18,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                            barsSpace: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: players.map((player) {
                      final playerStats = _zoneStats
                          .where((e) => e.playerName == player.name)
                          .toList();
                      return Card(
                        color: Colors.grey[700],
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              playerStats.isEmpty
                                  ? const Text(
                                      'Sem estatísticas',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : ZoneStatsChart(stats: playerStats),
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
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryChart() {
    final data = [
      _ChartData('Pontos', totalPoints.toDouble(), Colors.green),
      _ChartData('Erros', totalErrors.toDouble(), Colors.redAccent),
    ];

    double maxY = (totalPoints > totalErrors ? totalPoints : totalErrors) * 1.2;
    double interval = 10;
    while ((maxY / interval) > 5) {
      interval += 10;
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final d = data[group.x.toInt()];
                return BarTooltipItem(
                  '${d.label}: ${d.value.toInt()}',
                  TextStyle(color: d.color, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: interval,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  if (idx < 0 || idx >= data.length)
                    return const SizedBox.shrink();
                  return Text(
                    data[idx].label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTeamEfficiencyChart() {
    final List<TeamEfficiencyData> data = widget.teams.map((team) {
      final points = _pointsByTeam[team.id] ?? 0;
      final errors = _errorsByTeam[team.id] ?? 0;
      final efficiency = _efficiencyByTeam[team.id] ?? 0.0;
      return TeamEfficiencyData(
        teamName: team.name,
        points: points,
        errors: errors,
        efficiency: efficiency,
        color: Colors.green,
      );
    }).toList();

    double maxY =
        data.map((e) => e.points + e.errors).reduce((a, b) => a > b ? a : b) *
        1.2;
    double interval = 10;
    while ((maxY / interval) > 5) {
      interval += 10;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aproveitamento por Time',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final d = data[group.x.toInt()];
                    if (rodIndex == 0) {
                      return BarTooltipItem(
                        'Pontos: ${d.points}',
                        TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return BarTooltipItem(
                        'Erros: ${d.errors}',
                        TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int idx = value.toInt();
                      if (idx < 0 || idx >= data.length)
                        return const SizedBox.shrink();
                      final d = data[idx];
                      return Column(
                        children: [
                          Text(
                            d.teamName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${d.efficiency.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    reservedSize: 60,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((entry) {
                final idx = entry.key;
                final d = entry.value;
                return BarChartGroupData(
                  x: idx,
                  barRods: [
                    BarChartRodData(
                      toY: d.points.toDouble(),
                      color: Colors.green,
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    BarChartRodData(
                      toY: d.errors.toDouble(),
                      color: Colors.redAccent,
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                  barsSpace: 6,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerPerformanceChart(
    List<PlayerStatisticsSummaryDto> results,
  ) {
    List<LineChartBarData> lines = [];
    Map<String, Color> playerColors = {};

    for (int i = 0; i < results.length; i++) {
      var player = results[i];
      int cumulative = 0;
      List<FlSpot> spots = [];
      int index = 0;
      player.pointsByZone.forEach((zone, pts) {
        cumulative += pts;
        spots.add(FlSpot(index.toDouble(), cumulative.toDouble()));
        index++;
      });

      final color = Colors.primaries[i % Colors.primaries.length];
      playerColors[player.playerName] = color;

      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          dotData: FlDotData(show: true),
          color: color,
          barWidth: 3,
          isStrokeCapRound: true,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final playerName = results[spot.barIndex].playerName;
                      return LineTooltipItem(
                        '$playerName\n${spot.y.toInt()} pts',
                        TextStyle(
                          color: playerColors[playerName],
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (v, meta) => Text(
                      v.toInt().toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: lines,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: playerColors.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: entry.value),
                const SizedBox(width: 4),
                Text(entry.key, style: const TextStyle(color: Colors.white)),
              ],
            );
          }).toList(),
        ),
      ],
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
            color: Colors.grey[850],
            child: ExpansionTile(
              title: Text(
                team.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              children: players
                  .map(
                    (player) => ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: Text(
                        player.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ChartData {
  final String label;
  final double value;
  final Color color;
  _ChartData(this.label, this.value, this.color);
}

class TeamEfficiencyData {
  final String teamName;
  final int points;
  final int errors;
  final double efficiency;
  final Color color;
  TeamEfficiencyData({
    required this.teamName,
    required this.points,
    required this.errors,
    required this.efficiency,
    required this.color,
  });
}
