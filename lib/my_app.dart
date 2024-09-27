import 'package:basketball_statistics/app/widget/add_player.dart';
import 'package:basketball_statistics/app/widget/add_team.dart';
import 'package:basketball_statistics/app/widget/menu.dart';
import 'package:basketball_statistics/app/widget/player_list.dart';
import 'package:basketball_statistics/app/widget/team_list.dart';
import 'package:basketball_statistics/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basquete',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        Routes.menu : (context) => Menu(),
        Routes.teamList : (context) => TeamList(),
        Routes.addTeam: (context) => AddTeam(),
        Routes.playerList: (context) => PlayerList(),
        Routes.addPlayer: (context) => AddPlayer()
      },
    );
  }
}
