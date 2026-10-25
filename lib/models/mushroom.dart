import '../core/constants.dart';

class Mushroom {
  final String id;
  final String nameRu;
  final String nameEn;
  final String nameLatin;
  final String family;
  final String familyEn;
  final Edibility edibility;
  final String description;
  final String descriptionEn;
  final String season;
  final String seasonEn;
  final String habitat;
  final String habitatEn;
  final bool hasDoppelgangers;

  const Mushroom({
    required this.id,
    required this.nameRu,
    this.nameEn = '',
    required this.nameLatin,
    required this.family,
    this.familyEn = '',
    required this.edibility,
    required this.description,
    this.descriptionEn = '',
    required this.season,
    this.seasonEn = '',
    required this.habitat,
    this.habitatEn = '',
    this.hasDoppelgangers = false,
  });

  factory Mushroom.fromMap(String id, Map<String, dynamic> map) {
    return Mushroom(
      id: id,
      nameRu: (map['nameRu'] ?? map['namRu']) as String? ?? '',
      nameEn: map['nameEn'] as String? ?? '',
      nameLatin: map['nameLatin'] as String? ?? '',
      family: map['family'] as String? ?? '',
      familyEn: map['familyEn'] as String? ?? '',
      edibility: Edibility.fromValue(
        map['edibility'] as String? ?? 'Inedible',
      ),
      description: map['description'] as String? ?? '',
      descriptionEn: map['descriptionEn'] as String? ?? '',
      season: map['season'] as String? ?? '',
      seasonEn: map['seasonEn'] as String? ?? '',
      habitat: map['habitat'] as String? ?? '',
      habitatEn: map['habitatEn'] as String? ?? '',
      hasDoppelgangers: map['hasDoppelgangers'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameRu': nameRu,
      'nameEn': nameEn,
      'nameLatin': nameLatin,
      'family': family,
      'familyEn': familyEn,
      'edibility': edibility.value,
      'description': description,
      'descriptionEn': descriptionEn,
      'season': season,
      'seasonEn': seasonEn,
      'habitat': habitat,
      'habitatEn': habitatEn,
      'hasDoppelgangers': hasDoppelgangers,
    };
  }

  String localizedName(String language) {
    if (language == 'en') {
      if (nameEn.trim().isNotEmpty) {
        return nameEn;
      }

      if (nameLatin.trim().isNotEmpty) {
        return nameLatin;
      }
    }

    return nameRu;
  }

  String localizedFamily(String language) {
    if (language == 'en' && familyEn.trim().isNotEmpty) {
      return familyEn;
    }

    return family;
  }

  String localizedDescription(String language) {
    if (language == 'en' && descriptionEn.trim().isNotEmpty) {
      return descriptionEn;
    }

    return description;
  }

  String localizedSeason(String language) {
    if (language == 'en' && seasonEn.trim().isNotEmpty) {
      return seasonEn;
    }

    return season;
  }

  String localizedHabitat(String language) {
    if (language == 'en' && habitatEn.trim().isNotEmpty) {
      return habitatEn;
    }

    return habitat;
  }
}
