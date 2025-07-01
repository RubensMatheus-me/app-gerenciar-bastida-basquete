import 'package:datahoops/app/domain/dto/dto_assertiveness_pitch.dart';

abstract class IAssertivenessPitchDAO {
  Future<void> insert(AssertivenessPitchDTO pitch);
  Future<void> update(AssertivenessPitchDTO pitch);
  Future<void> delete(dynamic id);
  Future<AssertivenessPitchDTO?> getById(dynamic id);
  Future<List<AssertivenessPitchDTO>> getAll();
}
