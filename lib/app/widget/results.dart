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
              child: Text('Erro ao carregar resultados: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum resultado encontrado.'));
          }

          final stats = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vencedor: ${stats.winner}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildStatisticRow('Total de Pontos', stats.totalPoints.toString()),
                  _buildStatisticRow('Duração da Partida (min)', stats.durationMatch.toString()),
                  _buildStatisticRow('Total de Faltas', stats.totalFouls.toString()),
                  _buildStatisticRow('Diferença de Pontos', stats.pointsDifference.toString()),
                  _buildStatisticRow('Total de Rebotes', stats.totalRebounds.toString()),
                  _buildStatisticRow('Total de Assistências', stats.totalAssists.toString()),
                  _buildStatisticRow('Total de Turnovers', stats.totalTurnovers.toString()),
                  _buildStatisticRow('Time Vencedor?', stats.isWinner ? 'Sim' : 'Não'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
