class DTOTeam {
  int? id;
  String name;

  DTOTeam({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory DTOTeam.fromMap(Map<String, dynamic> map) {
    return DTOTeam(
      id: map['id'],
      name: map['name'],
    );
  }
}
