import 'dart:async';

import 'package:datahoops/app/database/sqlite/dao/imp_dao_player_statistics.dart';
import 'package:datahoops/app/domain/dto/dto_player_statistics.dart';
import 'package:datahoops/app/domain/enums/enum_match_type.dart';
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';
import 'package:datahoops/app/widget/results.dart';
import 'package:flutter/material.dart';
import 'package:datahoops/app/domain/dto/dto_player.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:datahoops/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:datahoops/app/widget/utils/player_miniature.dart';
import 'package:datahoops/app/domain/entities/match.dart' as app_match;

class PlayMatch extends StatefulWidget {
  final TeamDto teamA;
  final TeamDto teamB;
  final app_match.Match match;
  final MatchType matchType;

  const PlayMatch({
    Key? key,
    required this.teamA,
    required this.teamB,
    required this.match,
    required this.matchType,
  }) : super(key: key);

  @override
  State<PlayMatch> createState() => _PlayMatchState();
}

class _PlayMatchState extends State<PlayMatch> {
  late ImpDaoPlayer _daoPlayer;
  final Color backgroundColor = const Color(0xFF121212);

  Set<int> _threePointCells = {};

  List<PlayerDto> _playersTeamA = [];
  List<PlayerDto> _playersTeamB = [];

  final Map<int, ZoneType> _zoneMap = {};

  PlayerDto? _selectedPlayer;
  bool _isTeamAVisible = true;

  int? _activeCellIndex;
  Offset? _buttonPosition;

  final int rows = 5;
  final int cols = 9;

  Map<int, Color> highlightedCells = {};

  @override
  void initState() {
    super.initState();
    print('Match ID no initState: ${widget.match.id}');
    _daoPlayer = ImpDaoPlayer();
    _loadPlayers();
    _initializeHighlights();
    _initializeZoneMap();
  }

  Future<void> _onCellTapped(
    int points,
    int cellIndex,
    Offset globalTapPosition,
  ) async {
    setState(() {
      _activeCellIndex = cellIndex;
      _buttonPosition = globalTapPosition;
    });
  }

  Future<void> _registerShot(int points, int cellIndex, bool hit) async {
    if (_selectedPlayer == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um jogador antes de marcar pontos!'),
        ),
      );
      return;
    }

    final playerName = _selectedPlayer!.name;
    final resultText = hit ? 'Acerto' : 'Erro';
    final resultColor = hit ? Colors.green : Colors.red;
    ZoneType zone = _determineZoneFromCell(cellIndex);

    int row = cellIndex ~/ cols;
    int col = cellIndex % cols;
    print('Jogador: $playerName');
    print(
      'Clique na célula: index=$cellIndex, row=$row, col=$col, zone=$zone, pontos=$points, acerto=$hit',
    );

    final assertivenessPitchId = hit ? 1 : 2;

    if (widget.match.id == null) {
      throw Exception(
        "ID da partida está nulo. A partida deve ser inserida antes.",
      );
    }

    final statsDto = PlayerStatisticsDto(
      points: hit ? points : 0,
      zonePoint: zone.toString(),
      assertivenessPitchId: assertivenessPitchId,
      matchId: widget.match.id!,
      playerId: _selectedPlayer!.id,
    );

    await ImpDaoPlayerStatistics().insert(statsDto);
    print('Match ID no registershot: ${widget.match.id}');
    await _checkVictoryCondition();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$resultText: $points pontos por $playerName',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: resultColor,
        duration: const Duration(seconds: 1),
      ),
    );

    setState(() {});
  }

  bool _isThreePointCell(int cellIndex) {
    return _threePointCells.contains(cellIndex);
  }

  Future<void> _checkVictoryCondition() async {
    final matchId = widget.match.id!;
    final teamAId = widget.teamA.id!;
    final teamBId = widget.teamB.id!;
    final maxPoints = widget.match.maxPoints ?? 20;
    print('Match ID no checkVictory: ${matchId}');
    final statsDao = ImpDaoPlayerStatistics();
    final pointsA = await statsDao.getTotalPointsByTeam(teamAId, matchId);
    final pointsB = await statsDao.getTotalPointsByTeam(teamBId, matchId);

    if (pointsA >= maxPoints || pointsB >= maxPoints) {
      String winnerName = pointsA >= maxPoints
          ? widget.teamA.name
          : widget.teamB.name;

      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Results(
            match: widget.match,
            winnerTeam: winnerName,
            matchId: matchId!,
            teams: [widget.teamA, widget.teamB],
            playersByTeam: {
              widget.teamA.id!: _playersTeamA,
              widget.teamB.id!: _playersTeamB,
            },
          ),
        ),
      );
    }
  }

  ZoneType _determineZoneFromCell(int index) {
    return _zoneMap[index] ?? ZoneType.beyondArc;
  }

  Future<void> _loadPlayers() async {
    _playersTeamA = await _daoPlayer.getPlayerByTeam(widget.teamA.id!);
    _playersTeamB = await _daoPlayer.getPlayerByTeam(widget.teamB.id!);
    setState(() {});
  }

  void _initializeHighlights() {
    highlightedCells = {};
    _threePointCells = {};

    // parte amarela da quadra
    for (int col = 0; col < cols; col++) {
      highlightedCells[(rows - 1) * cols + col] = Colors.yellow.withValues(
        alpha: 0.5,
      );
    }
    for (int row = 0; row < rows; row++) {
      highlightedCells[row * cols] = Colors.yellow.withValues(alpha: 0.5);
      highlightedCells[row * cols + (cols - 1)] = Colors.yellow.withValues(
        alpha: 0.5,
      );
    }

    // parte azul da quadra
    int middleStart = (cols ~/ 2) - 1;
    for (int offset = 0; offset < 3; offset++) {
      highlightedCells[middleStart + offset] = Colors.blue.withValues(
        alpha: 0.5,
      );
    }

    int startRow = rows ~/ 3;
    int endRow = 2 * (rows ~/ 3);
    int startCol = cols ~/ 3;
    int endCol = 2 * (cols ~/ 3);
    for (int row = startRow; row < endRow; row++) {
      for (int col = startCol; col < endCol; col++) {
        highlightedCells[row * cols + col] = Colors.blue.withOpacity(0.5);
      }
    }

    for (int col = 0; col < cols; col++) {
      _threePointCells.add((rows - 1) * cols + col); // última linha
    }
    for (int row = 0; row < rows; row++) {
      _threePointCells.add(row * cols); // coluna esquerda
      _threePointCells.add(row * cols + (cols - 1)); // coluna direita
    }
  }

  void _initializeZoneMap() {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        int index = row * cols + col;

        ZoneType zone;

        if ((row >= 1 && row <= 2) && (col >= 3 && col <= 5)) {
          zone = ZoneType.paint;
        } else if ((row == 0 && (col >= 3 && col <= 5))) {
          zone = ZoneType.top;
        } else if (row == 4 && col <= 2) {
          zone = ZoneType.cornerLeft;
        } else if (row == 4 && col >= 6) {
          zone = ZoneType.cornerRight;
        } else if (row <= 1 && col <= 2) {
          zone = ZoneType.leftWing;
        } else if (row <= 1 && col >= 6) {
          zone = ZoneType.rightWing;
        } else {
          zone = ZoneType.beyondArc;
        }

        _zoneMap[index] = zone;

        print('index: $index | row: $row | col: $col => zone: $zone');
      }
    }
  }

  void _selectPlayer(PlayerDto player) {
    setState(() {
      _selectedPlayer = player;
    });
  }

  Future<void> _registerScore(int points, int cellIndex) async {
    if (_selectedPlayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um jogador antes de marcar pontos!'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '+$points - ${_selectedPlayer!.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    setState(() {});
  }

  Widget _buildFloatingButtons() {
    final screenSize = MediaQuery.of(context).size;
    final position =
        _buttonPosition ?? Offset(screenSize.width / 2, screenSize.height / 2);

    return Positioned(
      left: position.dx - 60,
      top: position.dy - 90,
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                final points = _isThreePointCell(_activeCellIndex!) ? 3 : 2;
                _registerShot(points, _activeCellIndex!, true);
                setState(() => _buttonPosition = null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                elevation: 4,
              ),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final points = _isThreePointCell(_activeCellIndex!) ? 3 : 2;
                _registerShot(points, _activeCellIndex!, false);
                setState(() => _buttonPosition = null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                elevation: 4,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerFooter() {
    return Container(
      height: 140,
      color: Colors.grey[900],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _isTeamAVisible
            ? _playersTeamA.length
            : _playersTeamB.length,
        itemBuilder: (context, index) {
          final player = _isTeamAVisible
              ? _playersTeamA[index]
              : _playersTeamB[index];
          final isSelected = _selectedPlayer?.id == player.id;

          return GestureDetector(
            onTap: () => _selectPlayer(player),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              padding: const EdgeInsets.all(4),
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.yellow : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[850],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[700],
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    player.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridButton(
    int row,
    int col,
    double buttonWidth,
    double buttonHeight,
  ) {
    int cellIndex = row * cols + col;

    int points = _isThreePointCell(cellIndex) ? 3 : 2;

    Color cellColor =
        highlightedCells[cellIndex] ??
        (points == 3
            ? Colors.yellow.withValues(alpha: 0.5)
            : Colors.red.withValues(alpha: 0.5));

    bool isRed = !highlightedCells.containsKey(cellIndex);

    return GestureDetector(
      onTapDown: (details) {
        final globalPosition = details.globalPosition;
        _onCellTapped(points, cellIndex, globalPosition);
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(color: cellColor),
      ),
    );
  }

  void _toggleTeam() {
    setState(() {
      _isTeamAVisible = !_isTeamAVisible;
      _selectedPlayer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Partida: ${widget.teamA.name} vs ${widget.teamB.name}'),
        backgroundColor: Colors.grey[700],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _buttonPosition = null;
              });
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final buttonWidth = constraints.maxWidth / cols;
                final buttonHeight = constraints.maxHeight / (rows + 1);

                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[200],
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                childAspectRatio: buttonWidth / buttonHeight,
                              ),
                          itemCount: rows * cols,
                          itemBuilder: (context, index) {
                            final row = index ~/ cols;
                            final col = index % cols;
                            return _buildGridButton(
                              row,
                              col,
                              buttonWidth,
                              buttonHeight,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: _toggleTeam,
                          icon: const Icon(Icons.swap_horiz),
                          label: Text(
                            _isTeamAVisible
                                ? 'Ver Jogadores do ${widget.teamB.name}'
                                : 'Ver Jogadores do ${widget.teamA.name}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    _buildPlayerFooter(),
                  ],
                );
              },
            ),
          ),
          if (_buttonPosition != null) _buildFloatingButtons(),
        ],
      ),
    );
  }
}
