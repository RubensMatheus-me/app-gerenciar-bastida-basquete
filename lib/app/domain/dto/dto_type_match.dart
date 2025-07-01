class TypeMatchDto {
  final dynamic id;
  final String type;

  TypeMatchDto({
    required this.id,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }

  factory TypeMatchDto.fromMap(Map<String, dynamic> map) {
    return TypeMatchDto(
      id: map['id'],
      type: map['type'],
    );
  }
}
