import 'package:datahoops/app/domain/enums/enum_match_type.dart';

class TypeMatch {
  final dynamic id;
  final MatchType type;

  TypeMatch({
    required this.id,
    required this.type,
  }) {
    _validateType();
  }

  void _validateType() {
    if (type.name.isEmpty) {
      throw Exception("Tipo de partida não pode ser vazio");
    }
  }
}
