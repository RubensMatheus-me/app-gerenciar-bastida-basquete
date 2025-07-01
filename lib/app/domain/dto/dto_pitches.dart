import 'package:datahoops/app/domain/entities/distance.dart';
import 'package:datahoops/app/domain/entities/pitches.dart';
import 'package:datahoops/app/domain/enums/enum_zone_type.dart';

class PitchesDto {
  final dynamic id;
  final String pitches;
  final dynamic distanceId;
  final String zoneType;

  PitchesDto({
    required this.id,
    required this.pitches,
    required this.distanceId,
    required this.zoneType,
  });

  factory PitchesDto.fromMap(Map<String, dynamic> map) {
    return PitchesDto(
      id: map['id'],
      pitches: map['pitches'],
      distanceId: map['distanceId'],
      zoneType: map['zoneType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pitches': pitches,
      'distanceId': distanceId,
      'zoneType': zoneType,
    };
  }

  Pitches toEntity({
    required Distance distance,
    required ZoneType zoneTypeEnum,
  }) {
    return Pitches(
      id: id,
      pitches: pitches,
      idDistance: distance,
      zoneType: zoneTypeEnum,
    );
  }

  factory PitchesDto.fromEntity(Pitches pitchesEntity) {
    return PitchesDto(
      id: pitchesEntity.id,
      pitches: pitchesEntity.pitches,
      distanceId: pitchesEntity.idDistance.id,
      zoneType: pitchesEntity.zoneType.toString(),
    );
  }
}
