import 'package:datahoops/app/domain/entities/distance.dart';
import 'package:datahoops/app/domain/enums/enum_distance_type.dart';

class DistanceDTO {
  final dynamic id;
  final String distance;

  DistanceDTO({
    required this.id,
    required this.distance,
  });

  factory DistanceDTO.fromModel(Distance model) {
    return DistanceDTO(
      id: model.id,
      distance: model.distance.name,
    );
  }

  Distance toModel() {
    return Distance(
      id: id,
      distance: DistanceType.values.firstWhere(
        (e) => e.name == distance,
        orElse: () => throw ArgumentError('Distância inválida: $distance'),
      ),
    );
  }
}
