import 'package:basketball_statistics/app/domain/interface/dao_player.dart';
import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_afterMatch.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_match.dart';
import 'package:basketball_statistics/app/widget/results.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';

class StartMatch extends StatefulWidget {
  final DTOTeam teamA;
  final DTOTeam teamB;
  final int matchId;

  const StartMatch({
    Key? key,
    required this.teamA,
    required this.teamB,
    required this.matchId,
  }) : super(key: key);

  @override
  _StartMatchState createState() => _StartMatchState();
}

class _StartMatchState extends State<StartMatch> {
  late IDAOPlayer _daoPlayer;
  List<DTOPlayer> _playersTeamA = [];
  List<DTOPlayer> _playersTeamB = [];
  DTOPlayer? _selectedPlayer;
  bool _isTeamAVisible = true; 

  final int rows = 5;
  final int cols = 9;
  Map<int, Color> highlightedCells = {};

  @override
  void initState() {
    super.initState();
    _daoPlayer = ImpDaoPlayer();
    _loadPlayers();
    _initializeHighlights();
  }

  Future<void> _loadPlayers() async {
    _playersTeamA = await _daoPlayer.getPlayersByTeam(widget.teamA.id!);
    _playersTeamB = await _daoPlayer.getPlayersByTeam(widget.teamB.id!);
    setState(() {});
  }

  void _initializeHighlights() {
    highlightedCells = {};
    int startRow = rows ~/ 3;
    int endRow = 2 * (rows ~/ 3);
    int startCol = cols ~/ 3;
    int endCol = 2 * (cols ~/ 3);

    for (int col = 0; col < cols; col++) {
      highlightedCells[(rows - 1) * cols + col] = Colors.yellow.withOpacity(0.5);
    }
    for (int row = 0; row < rows; row++) {
      highlightedCells[row * cols] = Colors.yellow.withOpacity(0.5);
      highlightedCells[row * cols + (cols - 1)] = Colors.yellow.withOpacity(0.5);
    }

    int middleStart = (cols ~/ 2) - 1;
    for (int offset = 0; offset < 3; offset++) {
      highlightedCells[middleStart + offset] = Colors.blue.withOpacity(0.5);
    }

    for (int row = startRow; row < endRow; row++) {
      for (int col = startCol; col < endCol; col++) {
        highlightedCells[row * cols + col] = Colors.blue.withOpacity(0.5);
      }
    }
  }

  void _selectPlayer(DTOPlayer player) {
    setState(() {
      _selectedPlayer = player;
    });
  }

void _registerScore(int points, int cellIndex) async {
  if (_selectedPlayer != null) {
    try {
      final daoMatch = ImpDaoMatch();
      final match = await daoMatch.getMatchById(widget.matchId);

      if (match == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar informações da partida.')),
        );
        return;
      }

      print('Antes da atualização do jogador: ${_selectedPlayer!.points}');

      _selectedPlayer!.points = (_selectedPlayer!.points ?? 0) + points;
      await _daoPlayer.updatePlayerMatchStats(
        _selectedPlayer!.id!,
        widget.matchId,
        points: _selectedPlayer!.points!,
      );

      if (_isTeamAVisible) {
        await daoMatch.updateMatchPoints(
          widget.matchId,
          match.pointsTeamA + points,
          match.pointsTeamB,
        );
      } else {
        await daoMatch.updateMatchPoints(
          widget.matchId,
          match.pointsTeamA,
          match.pointsTeamB + points,
        );
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

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar pontuação: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selecione um jogador antes de marcar pontos!')),
    );
  }
}
  
Widget _buildGridButton(int row, int col, double buttonWidth, double buttonHeight) {
  int cellIndex = row * cols + col;

  int points = highlightedCells[cellIndex] == Colors.yellow.withOpacity(0.5) ? 3 : 2;


  Color cellColor = highlightedCells[cellIndex] ??
      (points == 3 ? Colors.yellow.withOpacity(0.5) : Colors.red.withOpacity(0.5)); 
    return GestureDetector(
      onTap: () {
        _registerScore(points, cellIndex);
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        color: cellColor,
      ),
    );
  }

  Future<void> _finishMatch(BuildContext context) async {
    final daoMatch = ImpDaoMatch();
    final match = await daoMatch.getMatchById(widget.matchId);
    if (match != null) {
      match.isCompleted = true;
      await daoMatch.updateMatch(match);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Results(
          matchId: widget.matchId,
          dao: ImpDaoAfterMatch(),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao finalizar a partida.')),
      );
    }
  }

  void _toggleTeam() {
    setState(() {
      _isTeamAVisible = !_isTeamAVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partida: ${widget.teamA.name} vs ${widget.teamB.name}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = constraints.maxWidth / cols;
          final buttonHeight = constraints.maxHeight / (rows + 1);

          return Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: buttonWidth / buttonHeight,
                    ),
                    itemCount: rows * cols,
                    itemBuilder: (context, index) {
                      int row = index ~/ cols;
                      int col = index % cols;
                      return _buildGridButton(row, col, buttonWidth, buttonHeight);
                    },
                  ),
                ),
              ),
              Container(
                height: 120, 
                color: Colors.grey.shade200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (_isTeamAVisible ? _playersTeamA : _playersTeamB).length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),  
                  itemBuilder: (context, index) {
  final player = (_isTeamAVisible ? _playersTeamA : _playersTeamB)[index];

  return GestureDetector(
    onTap: () => _selectPlayer(player),
    child: Hero(
      tag: 'player-${player.id}', 
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8), 
        padding: const EdgeInsets.all(8),
        width: 120, 
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedPlayer == player ? Colors.yellow : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey, 
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              player.name,
              textAlign: TextAlign.center,  
              style: const TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold,
                fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _toggleTeam,
            child: const Icon(Icons.swap_horiz),
            tooltip: 'Trocar Time',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _finishMatch(context),
            child: const Icon(Icons.check),
            tooltip: 'Finalizar Partida',
          ),
        ],
      ),
    );
  }
}
