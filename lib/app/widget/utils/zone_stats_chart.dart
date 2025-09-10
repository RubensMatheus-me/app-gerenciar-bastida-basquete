import 'package:datahoops/app/domain/enums/enum_zone_type.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:datahoops/app/domain/dto/dto_player_zone_stats.dart';

class ZoneStatsChart extends StatelessWidget {
  final List<PlayerZoneStatsDto> stats;

  const ZoneStatsChart({Key? key, required this.stats}) : super(key: key);

  ZoneType zoneFromString(String zoneStr) {
    final cleaned = zoneStr.replaceAll("ZoneType.", "").trim();

    return ZoneType.values.firstWhere(
      (z) => z.name.toLowerCase() == cleaned.toLowerCase(),
      orElse: () {
        debugPrint("⚠️ Zona inválida recebida: '$zoneStr' → usando beyondArc");
        return ZoneType.beyondArc;
      },
    );
  }

  String formatZoneAbbr(ZoneType zone) {
    switch (zone) {
      case ZoneType.top: return "Centro";
      case ZoneType.leftWing: return "PE";   
      case ZoneType.rightWing: return "PD"; 
      case ZoneType.cornerLeft: return "CE"; 
      case ZoneType.cornerRight: return "CD";
      case ZoneType.paint: return "Garrafão";
      case ZoneType.beyondArc: return "3PT";
    }
  }

  String formatZoneFullName(ZoneType zone) {
    switch (zone) {
      case ZoneType.top: return "Área Central";
      case ZoneType.leftWing: return "Ponta Esquerda";
      case ZoneType.rightWing: return "Ponta Direita";
      case ZoneType.cornerLeft: return "Canto Esquerdo";
      case ZoneType.cornerRight: return "Canto Direito";
      case ZoneType.paint: return "Garrafão";
      case ZoneType.beyondArc: return "Linha de 3";
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<ZoneType, double> groupedData = {};

    for (var stat in stats) {
      final zone = zoneFromString(stat.zonePoint);
      groupedData.update(
        zone,
        (value) => value + stat.totalAttempts,
        ifAbsent: () => stat.totalAttempts.toDouble(),
      );
    }

    final sortedEntries = groupedData.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));

    final zonesAbbr = sortedEntries.map((e) => formatZoneAbbr(e.key)).toList();
    final zonesFull = sortedEntries.map((e) => formatZoneFullName(e.key)).toList();
    final values = sortedEntries.map((e) => e.value).toList();

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < zonesAbbr.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: values[i],
              color: Colors.blueAccent,
              width: 18,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) * 1.2 : 5,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  "${zonesFull[groupIndex]}: ${rod.toY.toInt()}",
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
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
                  int index = value.toInt();
                  if (index < 0 || index >= zonesAbbr.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      zonesAbbr[index],
                      style: const TextStyle(fontSize: 12, color: Colors.white),
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
          barGroups: barGroups,
        ),
      ),
    );
  }
}
