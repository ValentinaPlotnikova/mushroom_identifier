import '../core/constants.dart';
import 'doppelganger.dart';
import 'mushroom.dart';

class MushroomModel {
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

  final List<String> imageUrls;
  final List<Doppelganger> doppelgangers;

  const MushroomModel({
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
    this.imageUrls = const [],
    this.doppelgangers = const [],
  });

  bool get isDeadly => edibility == Edibility.deadlyPoisonous;

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

  factory MushroomModel.fromMushroom(
    Mushroom mushroom, {
    List<String> imageUrls = const [],
    List<Doppelganger> doppelgangers = const [],
  }) {
    return MushroomModel(
      id: mushroom.id,
      nameRu: mushroom.nameRu,
      nameEn: mushroom.nameEn,
      nameLatin: mushroom.nameLatin,
      family: mushroom.family,
      familyEn: mushroom.familyEn,
      edibility: mushroom.edibility,
      description: mushroom.description,
      descriptionEn: mushroom.descriptionEn,
      season: mushroom.season,
      seasonEn: mushroom.seasonEn,
      habitat: mushroom.habitat,
      habitatEn: mushroom.habitatEn,
      hasDoppelgangers: mushroom.hasDoppelgangers,
      imageUrls: imageUrls,
      doppelgangers: doppelgangers,
    );
  }

  Mushroom toMushroom() {
    return Mushroom(
      id: id,
      nameRu: nameRu,
      nameEn: nameEn,
      nameLatin: nameLatin,
      family: family,
      familyEn: familyEn,
      edibility: edibility,
      description: description,
      descriptionEn: descriptionEn,
      season: season,
      seasonEn: seasonEn,
      habitat: habitat,
      habitatEn: habitatEn,
      hasDoppelgangers: hasDoppelgangers,
    );
  }
}
