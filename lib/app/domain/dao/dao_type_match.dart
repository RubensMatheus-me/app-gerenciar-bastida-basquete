import 'package:datahoops/app/domain/dto/dto_type_match.dart';

abstract class ITypeMatchDao {
  Future<void> save(TypeMatchDto dto);
  Future<void> delete(dynamic id);
  Future<List<TypeMatchDto>> findAll();
  Future<TypeMatchDto?> findById(dynamic id);
}
