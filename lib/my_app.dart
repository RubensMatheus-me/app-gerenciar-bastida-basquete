import 'package:basketball_statistics/app/widget/add_player.dart';
import 'package:basketball_statistics/app/widget/add_team.dart';
import 'package:basketball_statistics/app/widget/menu.dart';
import 'package:basketball_statistics/app/widget/player_list.dart';
import 'package:basketball_statistics/app/widget/team_list.dart';
import 'package:basketball_statistics/app/widget/select_teams.dart'; 
import 'package:basketball_statistics/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basquete',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        Routes.menu: (context) => Menu(),
        Routes.teamList: (context) => TeamList(),
        Routes.addTeam: (context) => AddTeam(
          refreshTeams: () {
            final teamListState = context.findAncestorStateOfType<TeamListState>();
            teamListState?.loadTeams();
          },
        ),
        Routes.addPlayer: (context) => AddPlayer(),
        Routes.playerList: (context) {
          final teamId = ModalRoute.of(context)!.settings.arguments as int;
          return PlayerList(teamId: teamId);
        },
        Routes.selectTeam: (context) => SelectTeams(),
      },
    );
  }
}
