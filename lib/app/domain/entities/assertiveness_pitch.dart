class AssertivenessPitch {
  final dynamic id;
  final String description;

  AssertivenessPitch({
    required this.id,
    required String description,
  }) : description = _validateDescription(description);

  static String _validateDescription(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      throw ArgumentError("A descrição não pode estar vazia.");
    }

    if (trimmed.length < 3) {
      throw ArgumentError("A descrição deve ter pelo menos 3 caracteres.");
    }

    final validPattern = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!validPattern.hasMatch(trimmed)) {
      throw ArgumentError("A descrição deve conter apenas letras e espaços.");
    }

    return trimmed;
  }
}
