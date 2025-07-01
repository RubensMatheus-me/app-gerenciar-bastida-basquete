import 'package:datahoops/app/domain/dto/dto_pitches.dart';

abstract class IPitchesDao {
  Future<int> insert(PitchesDto pitches);
  Future<int> update(PitchesDto pitches);
  Future<int> delete(dynamic id);
  Future<PitchesDto?> getById(dynamic id);
  Future<List<PitchesDto>> getAll();
}
