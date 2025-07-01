import 'package:datahoops/app/widget/add_player.dart';
import 'package:datahoops/app/widget/add_team.dart';
import 'package:datahoops/app/widget/manage_team.dart';
import 'package:datahoops/app/widget/select_team.dart';
import 'package:datahoops/app/widget/team_list.dart';
import 'package:datahoops/routes.dart';
import 'package:flutter/material.dart';
import 'package:datahoops/app/widget/menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataHoops',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Routes.menu,
      routes: {
        Routes.menu: (context) => Menu(),
        Routes.manageTeam: (context) => ManageTeam(),
        Routes.addTeam: (context) => AddTeam(),
        Routes.addPlayer: (context) => AddPlayer(),
        Routes.teamList: (context) => TeamList(),
        Routes.selectTeam: (context) => SelectTeam(),
      },
    );
  }
}