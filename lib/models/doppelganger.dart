class Doppelganger {
  final String id;
  final String mushroomId;
  final String similarMushroomId;
  final String differences;
  final String differencesEn;

  const Doppelganger({
    required this.id,
    required this.mushroomId,
    required this.similarMushroomId,
    this.differences = '',
    this.differencesEn = '',
  });

  factory Doppelganger.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Doppelganger(
      id: id,
      mushroomId: map['mushroomId'] as String? ?? '',
      similarMushroomId: map['similarMushroomId'] as String? ?? '',
      differences: map['differences'] as String? ?? '',
      differencesEn: map['differencesEn'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mushroomId': mushroomId,
      'similarMushroomId': similarMushroomId,
      'differences': differences,
      'differencesEn': differencesEn,
    };
  }

  String localizedDifferences(String language) {
    if (language == 'en' && differencesEn.trim().isNotEmpty) {
      return differencesEn;
    }

    return differences;
  }
}
