import 'package:basketball_statistics/routes.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {

  Widget getButton(BuildContext context, String route, String text) {
    return TextButton(onPressed: () => Navigator.pushNamed(context, route), child: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          getButton(context, Routes.addTeam, 'Adicionar Time'),
          getButton(context, Routes.addTeam, 'Adicionar Jogador')
          
        ],
      ),
    );
  }
}
