import 'package:datahoops/app/domain/dto/dto_distance.dart';

abstract class IDistanceDAO {
  Future<void> save(DistanceDTO distance);
  Future<void> delete(dynamic id);
  Future<List<DistanceDTO>> findAll();
  Future<DistanceDTO?> findById(dynamic id);
}
