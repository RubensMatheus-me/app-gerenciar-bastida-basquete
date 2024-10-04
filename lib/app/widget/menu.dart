import 'package:basketball_statistics/routes.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  Widget getButton(
      BuildContext context, String route, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, size: 24),
        label: Text(text, style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Menu',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            getButton(context, Routes.startMatch, 'Começar Partida',
                Icons.play_arrow),
            getButton(
                context, Routes.addTeam, 'Adicionar Time', Icons.group_add),
            getButton(context, Routes.addPlayer, 'Adicionar Jogador',
                Icons.person_add),
            getButton(context, Routes.teamList, 'Exibir Times', Icons.list),
          ],
        ),
      ),
    );
  }
}
