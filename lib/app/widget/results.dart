import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/domain/interface/dao_afterMatch.dart';
import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';

class Results extends StatelessWidget {
  final int matchId;
  final IDaoAftermatch dao; // Assumindo que você vai passar o DAO também

  Results({Key? key, required this.matchId, required this.dao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados da Partida'),
      ),
      body: FutureBuilder<DTOAfterMatch>(
        future: dao.getMatchStatistics(matchId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar resultados: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nenhum resultado encontrado.'));
          }

          final stats = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vencedor: ${stats.winner}',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Total de Pontos: ${stats.totalPoints}',
                    style: TextStyle(fontSize: 20)),
                Text('Diferença de Pontos: ${stats.pointsDifference}',
                    style: TextStyle(fontSize: 20)),
                Text('Total de Faltas: ${stats.totalFouls}',
                    style: TextStyle(fontSize: 20)),
                Text('Total de Rebotes: ${stats.totalRebounds}',
                    style: TextStyle(fontSize: 20)),
                Text('Total de Assistências: ${stats.totalAssists}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Text('Duração da Partida: ${stats.durationMatch}',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          );
        },
      ),
    );
  }
}
