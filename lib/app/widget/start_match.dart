import 'package:basketball_statistics/app/domain/interface/dao_player.dart';
import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_afterMatch.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_match.dart';
import 'package:basketball_statistics/app/widget/results.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:basketball_statistics/app/widget/player_miniature.dart';

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
  final Map<int, Offset> _playerPositions = {};
  late int _matchId;

  @override
  void initState() {
    super.initState();
    _daoPlayer = ImpDaoPlayer();
    _loadPlayers();
  }

  Future<void> _initializeMatchId() async {
    final daoMatch = ImpDaoMatch();
    final match = await daoMatch.getMatchForTeams(widget.teamA.id!, widget.teamB.id!);
    if (match != null) {
      setState(() {
        _matchId = match.id!;
      });
    } else {
      throw Exception('Partida não encontrada para essas equipes');
    }
  }

  Future<void> _loadPlayers() async {
    _playersTeamA = await _daoPlayer.getPlayersByTeam(widget.teamA.id!);
    _playersTeamB = await _daoPlayer.getPlayersByTeam(widget.teamB.id!);
    setState(() {});
  }

  void _selectPlayer(DTOPlayer player) {
    setState(() {
      _selectedPlayer = player;
    });
  }

  void _registerScore(int points) {
    if (_selectedPlayer != null) {
      print("Jogador ${_selectedPlayer!.name} marcou $points pontos!");
    } else {
      print("Nenhum jogador selecionado.");
    }
  }

  Widget _buildQuadrant({
    required Color color,
    required double left,
    required double top,
    required double width,
    required double height,
    required int points,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          if (_selectedPlayer != null) {
            _registerScore(points);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selecione um jogador antes de marcar pontos!')),
            );
          }
        },
        child: Container(
          width: width,
          height: height,
          color: color.withOpacity(0.3),
        ),
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
          _buildQuadrant(
            color: Colors.green,
            left: 620,
            top: 150,
            width: 100,
            height: 100,
            points: 2,
          ),
          _buildQuadrant(
            color: Colors.red,
            left: 300,
            top: 150,
            width: 100,
            height: 100,
            points: 3,
          ),
          _buildQuadrant( 
            color: Colors.red,
            left: 950,
            top: 150,
            width: 100,
            height: 100,
            points: 3,
          ),
          // Jogadores
          ...buildPlayerWidgets(_playersTeamA),
          ...buildPlayerWidgets(_playersTeamB),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _finishMatch(context),
        child: Icon(Icons.check),
        tooltip: 'Finalizar Partida',
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
            feedback: Material(
              color: Colors.transparent,
              child: PlayerMiniature(
                name: player.name,
                isSelected: _selectedPlayer?.id == player.id,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5, 
              child: PlayerMiniature(
                name: player.name,
                isSelected: _selectedPlayer?.id == player.id,
              ),
            ),
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
