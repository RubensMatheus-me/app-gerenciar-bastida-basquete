import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/domain/dto/dto_player.dart';
import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';

class PlayerList extends StatelessWidget {
  final int teamId;

  const PlayerList({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores do Time'),
      ),
      body: FutureBuilder<List<DTOPlayer>>(
        future: ImpDaoTeam().getPlayersForTeam(teamId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum jogador encontrado'));
          }

          List<DTOPlayer> players = snapshot.data!;
          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              var player = players[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(player.name),
                subtitle: Text('Posição: ${player.position}'),
              );
            },
          );
        },
      ),
    );
  }
}
