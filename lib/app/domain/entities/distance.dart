import 'package:datahoops/app/domain/enums/enum_distance_type.dart';

class Distance {
  final dynamic id;
  final DistanceType distance;

  Distance({
    required this.id,
    required DistanceType distance,
  }) : distance = _validateDistance(distance);

  static DistanceType _validateDistance(DistanceType distance) {
    if (distance == null) {
      throw ArgumentError('A distância não pode ser nula.');
    }
    return distance;
  }
}
