import 'package:datahoops/app/database/sqlite/dao/imp_dao_player.dart';
import 'package:datahoops/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:datahoops/app/domain/dto/dto_player.dart';
import 'package:datahoops/app/domain/dto/dto_team.dart';
import 'package:datahoops/app/domain/entities/player.dart';
import 'package:datahoops/app/domain/entities/team.dart';
import 'package:datahoops/app/widget/add_player.dart';
import 'package:datahoops/app/widget/add_team.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamList extends StatefulWidget {
  const TeamList({super.key});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  final Color accentColor = const Color(0xFFEF6C00);
  final Color backgroundColor = const Color(0xFF121212);
  late Future<List<TeamDto>> _teamsFuture;

  @override
  void initState() {
    super.initState();
    _teamsFuture = ImpDaoTeam().getAll();
  }

  Future<List<PlayerDto>> _getPlayersByTeam(int teamId) async {
    final allPlayers = await ImpDaoPlayer().findAll();
    return allPlayers.where((p) => p.teamId == teamId).toList();
  }

  void _editTeams(TeamDto team) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTeam(teamToEdit: team),
      )
    );

    if (updated == true) {
      setState(() {
        _teamsFuture = ImpDaoTeam().getAll();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Time '${team.name}' atualizado com sucesso")),
      );
    }
  }

  void _deleteTeam(TeamDto team) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusao'),
        content: Text('Desejo excluir o time  "${team.name}"?'),
        actions: [
          TextButton(
            child: Text('Cancelar', style: TextStyle(color: accentColor)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text('Excluir', style: TextStyle(color: Colors.redAccent)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      )
    );
    if(confirm == true) {
      await ImpDaoTeam().delete(team.id!);
      setState(() {
      _teamsFuture = ImpDaoTeam().getAll();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Time '${team.name}' excluído com sucesso.")),
      );
    }
  }

  void _showPlayers(BuildContext context, TeamDto team) async {
    final players = await _getPlayersByTeam(team.id);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.grey[900],
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jogadores de ${team.name}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 12),
            if (players.isEmpty)
              Center(
                child: Text(
                  'Nenhum jogador neste time.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: players.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey[700]),
                
                itemBuilder: (_, index) {
                  final p = players[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: accentColor.withValues(alpha: 0.15),
                      foregroundColor: accentColor,
                      child: Text(
                        p.name[0].toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      p.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    
                    ),
                    
                    subtitle: Text(
                      'Camisa ${p.shirtNumber} • ${p.position}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[300],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blueAccent,
                          tooltip: 'Editar jogador',
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddPlayer(playerToEdit: p),
                              ),
                            );
                            if (updated != null) {
                              final updatedPlayer = updated['player'] as Player;
                              final updatedTeam = updated['team'] as TeamDto;
                              
                              setState(() {
                                _teamsFuture = ImpDaoTeam().getAll();
                              });

                              Navigator.pop(context);
                              
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _showPlayers(context, updatedTeam);
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                          tooltip: 'Excluir jogador',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text('Deseja excluir ${p.name}?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar', style: TextStyle(color: accentColor)),
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                  ),
                                  TextButton(
                                    child: Text('Excluir', style: TextStyle(color: Colors.redAccent)),
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await ImpDaoPlayer().delete(p.id!);
                              setState(() {});
                              Navigator.pop(context);
                              _showPlayers(context, team);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Times Registrados',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white, 
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: accentColor),
      ),
      backgroundColor: Colors.grey[900],
      body: FutureBuilder<List<TeamDto>>(
        future: _teamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}',
                  style: GoogleFonts.poppins(color: Colors.red)),
            );
          }

          final teams = snapshot.data ?? [];
          if (teams.isEmpty) {
            return Center(
              child: Text(
                'Nenhum time cadastrado.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: teams.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final team = teams[index];
              return Card(
                color: Colors.grey[850],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    team.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.group),
                        color: accentColor,
                        tooltip: 'Ver jogadores',
                        onPressed: () => _showPlayers(context, team),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blueAccent,
                        tooltip: 'Editar time',
                        onPressed: () => _editTeams(team),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                        tooltip: 'Excluir time',
                        onPressed: () => _deleteTeam(team),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
