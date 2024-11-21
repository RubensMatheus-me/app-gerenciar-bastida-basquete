import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_match.dart';
import 'package:basketball_statistics/app/widget/start_match.dart';
import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart'; 

class SelectTeams extends StatefulWidget {
  const SelectTeams({super.key});

  @override
  _SelectTeams createState() => _SelectTeams();
}

class _SelectTeams extends State<SelectTeams> {
  List<DTOTeam> _teams = [];
  List<DTOPlayer> _playersTeamA = [];
  List<DTOPlayer> _playersTeamB = []; 
  DTOTeam? _selectedTeamA;
  DTOTeam? _selectedTeamB;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    var teams = await ImpDaoTeam().getAllTeams();
    setState(() {
      _teams = teams;
    });
  }

  Future<void> _loadPlayersByTeam(DTOTeam? team, bool isTeamA) async {
    if (team != null) {
      var players = await ImpDaoPlayer().getPlayersByTeam(team.id);
      setState(() {
        if (isTeamA) {
          _playersTeamA = players; 
        } else {
          _playersTeamB = players; 
        }
      });
    }
  }

  void _startMatch() async {
    if (_selectedTeamA != null && _selectedTeamB != null) {
    final daoMatch = ImpDaoMatch();
    final match = await daoMatch.getMatchForTeams(_selectedTeamA!.id!, _selectedTeamB!.id!);

    if (match != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StartMatch(
            teamA: _selectedTeamA!,
            teamB: _selectedTeamB!,
            matchId: match.id!, 
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Não foi encontrada uma partida para essas equipes.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, selecione dois times.')),
    );
  }
  }

  List<Widget> _buildPlayerList(List<DTOPlayer> players) {
    if (players.isEmpty) return [const Text('Nenhum jogador selecionado.')];

    return players.map((player) => Text(player.name)).toList(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Times'),
      ),
      body: _teams.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            DropdownButton<DTOTeam>(
                              hint: const Text('Selecione o Time A'),
                              value: _selectedTeamA,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTeamA = value;
                                  _loadPlayersByTeam(value, true);
                                });
                              },
                              items: _teams.map((team) {
                                return DropdownMenuItem<DTOTeam>(
                                  value: team,
                                  child: Text(team.name),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildPlayerList(_playersTeamA),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            DropdownButton<DTOTeam>(
                              hint: const Text('Selecione o Time B'),
                              value: _selectedTeamB,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTeamB = value;
                                  _loadPlayersByTeam(value, false); 
                                });
                              },
                              items: _teams.map((team) {
                                return DropdownMenuItem<DTOTeam>(
                                  value: team,
                                  child: Text(team.name),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildPlayerList(_playersTeamB),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startMatch,
                      child: const Text('Iniciar Partida'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
