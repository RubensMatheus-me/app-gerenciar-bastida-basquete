import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/domain/interface/dao_afterMatch.dart';
import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';

class Results extends StatelessWidget {
  final int matchId;
  final IDaoAftermatch dao;

  const Results({Key? key, required this.matchId, required this.dao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Partida'),
      ),
      body: FutureBuilder<DTOAfterMatch>(
        future: dao.getMatchStatistics(matchId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Erro ao carregar resultados: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => {}, // Implementar tentativa novamente.
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum resultado encontrado.'));
          }

          final stats = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(stats),
                const Divider(height: 20),
                _buildTeamStats(stats),
                const Divider(height: 20),
                _buildPlayerStats(stats),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DTOAfterMatch stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vencedor: ${stats.winner}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildStatisticRow('Total de Pontos', stats.totalPoints.toString()),
      ],
    );
  }

  Widget _buildTeamStats(DTOAfterMatch stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas por Equipe:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _buildStatisticRow('Pontos - Equipe A', stats.pointsTeamA.toString()),
        _buildStatisticRow('Pontos - Equipe B', stats.pointsTeamB.toString()),
      ],
    );
  }

  Widget _buildPlayerStats(DTOAfterMatch stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas por Jogador:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.players.length,
          itemBuilder: (context, index) {
            final player = stats.players[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(player.tShirtNumber.toString()),
                ),
                title: Text(player.name),
                subtitle: Text(
                 'Pontos: ${player.points ?? 0}', // Garantir que não seja nulo
  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDuration(double duration) {
    final minutes = duration.floor();
    final seconds = ((duration - minutes) * 60).round();
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  Widget _buildStatisticRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
