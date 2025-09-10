import 'package:flutter/material.dart';

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
