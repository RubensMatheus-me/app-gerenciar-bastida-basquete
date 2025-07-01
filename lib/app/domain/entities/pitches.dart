import 'package:datahoops/app/domain/entities/distance.dart';
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';

class Pitches {
  final dynamic id;
  final String pitches;
  final Distance idDistance;
  final ZoneType zoneType;

  Pitches({
    required this.id,
    required this.pitches,
    required this.idDistance,
    required this.zoneType,
  }) {
    if (pitches.trim().isEmpty) {
      throw ArgumentError('Os arremessos não podem ser vazio.');
    }
  }
}
