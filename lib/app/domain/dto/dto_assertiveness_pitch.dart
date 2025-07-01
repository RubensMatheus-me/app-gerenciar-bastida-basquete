class AssertivenessPitchDTO {
  final dynamic id;
  final String description;

  AssertivenessPitchDTO({
    required this.id,
    required this.description,
  });

  factory AssertivenessPitchDTO.fromMap(Map<String, dynamic> map) {
    return AssertivenessPitchDTO(
      id: map['id'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
    };
  }
}
