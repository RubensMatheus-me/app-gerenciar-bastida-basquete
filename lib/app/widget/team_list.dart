import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:flutter/material.dart';
import 'package:basketball_statistics/routes.dart';

class TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Times'),
      ),
      body: FutureBuilder<List<DTOTeam>>(
        future: ImpDaoTeam().getAllTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum time encontrado'));
          }

          List<DTOTeam> teams = snapshot.data!;
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              var team = teams[index];
              return ListTile(
                leading: Icon(Icons.sports_basketball),
                title: Text(team.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('ID: ${team.id}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.playerList,
                    arguments: team.id!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
