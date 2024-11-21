import 'package:basketball_statistics/app/database/sqlite/dao/imp_dao_team.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';
import 'package:basketball_statistics/app/widget/add_team.dart';
import 'package:basketball_statistics/routes.dart';
import 'package:flutter/material.dart';

class TeamList extends StatefulWidget {
  const TeamList({super.key});

  @override
  TeamListState createState() => TeamListState();
}

class TeamListState extends State<TeamList> {
  List<DTOTeam> _teams = [];

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  void loadTeams() {
    ImpDaoTeam().getAllTeams().then((teams) {
      setState(() {
        _teams = teams;
      });
    });
  }

  void _navigateToAddTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTeam(refreshTeams: loadTeams),
      ),
    ).then((_) {
      loadTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Times'),
      ),
      body: FutureBuilder<List<DTOTeam>>(
        future: ImpDaoTeam().getAllTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum time encontrado'));
          }

          List<DTOTeam> teams = snapshot.data!;
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              var team = teams[index];
              return ListTile(
                leading: const Icon(Icons.sports_basketball),
                title: Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
