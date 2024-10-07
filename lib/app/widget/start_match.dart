import 'package:flutter/material.dart';
import 'package:basketball_statistics/app/domain/dto/dto_team.dart';

class StartMatch extends StatelessWidget {
  final DTOTeam teamA;
  final DTOTeam teamB;

  const StartMatch(
    {
      Key? key,
      required this.teamA,
     required this.teamB
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partida: ${teamA.name} vs ${teamB.name}'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/basketball_court.png',
            fit: BoxFit.cover,
          ),

          Positioned(
            left: 50,
            top: 100,
            child: Draggable(
              feedback: PlayerMiniature(name: 'Jogador A'),
              child: PlayerMiniature(name: 'Jogador A'),
              childWhenDragging: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerMiniature extends StatelessWidget {
  final String name;

  PlayerMiniature({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue, // Cor do jogador
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
