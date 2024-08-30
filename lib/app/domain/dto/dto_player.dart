import 'package:basketball_statistics/app/domain/entities/team.dart';

class DTOPlayer {
  late dynamic id;
  late String name;
  late String position;
  late int tShirtNumber;
  late Team association;

  DTOPlayer({this.id, required this.name, required this.position, required this.tShirtNumber, required this.association});
}
