import 'package:basketball_statistics/app/domain/entities/player.dart';

class Basketball {
  late double positionX;
  late double positionY;
  late Player? player;

  Basketball({required this.positionX, required this.positionY, this.player});

  updatePosition(double newPositionX, newPositionY) {
    positionX = newPositionX;
    positionY = newPositionY;
  }

  associatePlayer(Player selectedPlayer) {
    player = selectedPlayer;
  }


  int determinatePoints() {
  /*
  if(y < 3) {
     return 3; // Cesta de 3 pontos
    }
    return 2; // Cesta de 2 pontos
    */
    return determinatePoints();
  }
  
  
}