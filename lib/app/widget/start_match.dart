import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/domain/interface/dao_player.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';

class StartMatch extends StatefulWidget {
  final DTOTeam teamA;
  final DTOTeam teamB;

  const StartMatch({
    Key? key,
    required this.teamA,
    required this.teamB,
  }) : super(key: key);

  @override
  _StartMatchState createState() => _StartMatchState();
}

class _StartMatchState extends State<StartMatch> {
  late IDAOPlayer _daoPlayer;
  List<DTOPlayer> _playersTeamA = [];
  List<DTOPlayer> _playersTeamB = [];
  DTOPlayer? _selectedPlayer;
  final Map<int, Offset> _playerPositions = {};

  @override
  void initState() {
    super.initState();
    _daoPlayer = ImpDaoPlayer();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    _playersTeamA = await _daoPlayer.getPlayersByTeam(widget.teamA.id!);
    _playersTeamB = await _daoPlayer.getPlayersByTeam(widget.teamB.id!);

    for (int i = 0; i < _playersTeamA.length; i++) {
      _playerPositions[_playersTeamA[i].id!] = Offset(100, 100 + i * 60);
    }
    for (int i = 0; i < _playersTeamB.length; i++) {
      _playerPositions[_playersTeamB[i].id!] = Offset(300, 100 + i * 60);
    }

    setState(() {});
  }

  void _selectPlayer(DTOPlayer player) {
    setState(() {
      _selectedPlayer = player;
    });
  }

  void _addPoints(int points) {
    if (_selectedPlayer != null) {
      print("Jogador ${_selectedPlayer!.name} fez $points pontos");
    } else {
      print("Nenhum jogador selecionado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partida: ${widget.teamA.name} vs ${widget.teamB.name}'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/quadra3x3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ...buildPlayerWidgets(_playersTeamA),
          ...buildPlayerWidgets(_playersTeamB),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () => _addPoints(1),
                  child: const Text('+1'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () => _addPoints(2),
                  child: const Text('+2'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () => _addPoints(3),
                  child: const Text('+3'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    if (_selectedPlayer != null) {
                      print("Falta cometida por ${_selectedPlayer!.name}");
                    }
                  },
                  child: const Text('Falta'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    if (_selectedPlayer != null) {
                      print("Arremesso de ${_selectedPlayer!.name}");
                    }
                  },
                  child: const Text('Arremesso'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPlayerWidgets(List<DTOPlayer> players) {
  return List.generate(players.length, (index) {
    final player = players[index];
    final position = _playerPositions[player.id];

    if (position == null) {
      _playerPositions[player.id!] = Offset(100, 100 + index * 60);
    }

    return Positioned(
      left: _playerPositions[player.id!]!.dx,
      top: _playerPositions[player.id!]!.dy,
      child: GestureDetector(
        onTap: () => _selectPlayer(player),
        child: Draggable(
          feedback: Hero(
            tag: 'player_${player.id}',
            child: Material(
              color: Colors.transparent,
              child: PlayerMiniature(
                name: player.name,
                isSelected: _selectedPlayer?.id == player.id,
              ),
            ),
          ),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            setState(() {
              _playerPositions[player.id!] = Offset(
                details.offset.dx - (50 / 2),
                details.offset.dy - (50 / 2),
                );
              });
            },
          child: PlayerMiniature(
            name: player.name,
            isSelected: _selectedPlayer?.id == player.id, 
          ),
          ),
        ),
      );
    });
  }
}

class PlayerMiniature extends StatelessWidget {
  final String name;
  final bool isSelected; 

  const PlayerMiniature({Key? key, required this.name, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(color: Colors.yellow, width: 3)
            : null,
        borderRadius: BorderRadius.circular(10), 
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person, size: 50),
          const SizedBox(height: 4),
          Text(name),
        ],
      ),
    );
  }
}
