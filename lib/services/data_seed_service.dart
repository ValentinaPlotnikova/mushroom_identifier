import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import 'firebase_service.dart';

class DataSeedService {
  final FirebaseFirestore _db = FirebaseService.instance.firestore;

  Future<void> seedIfNeeded() async {
    final mushrooms =
        await _db.collection(AppConstants.mushroomsCollection).limit(1).get();

    if (mushrooms.docs.isEmpty) {
      await _seedMushrooms();
    }

    final doppelgangers = await _db
        .collection(AppConstants.doppelgangersCollection)
        .limit(1)
        .get();

    if (doppelgangers.docs.isEmpty) {
      await _seedDoppelgangers();
    }

    final images = await _db
        .collection(AppConstants.mushroomImagesCollection)
        .limit(1)
        .get();

    if (images.docs.isEmpty) {
      await _seedImages();
    }

    await _addMissingEnglishTranslations();
  }

  Future<void> _seedMushrooms() async {
    final batch = _db.batch();

    for (final entry in _mushrooms) {
      final ref = _db
          .collection(AppConstants.mushroomsCollection)
          .doc(entry['id'] as String);

      final data = Map<String, dynamic>.from(entry)..remove('id');

      batch.set(ref, data);
    }

    await batch.commit();
  }

  Future<void> _seedDoppelgangers() async {
    final batch = _db.batch();

    for (final entry in _doppelgangers) {
      final ref = _db.collection(AppConstants.doppelgangersCollection).doc();

      batch.set(ref, entry);
    }

    await batch.commit();
  }

  Future<void> _seedImages() async {
    final batch = _db.batch();

    for (final entry in _images) {
      final ref = _db.collection(AppConstants.mushroomImagesCollection).doc();

      batch.set(ref, entry);
    }

    await batch.commit();
  }

  Future<void> _addMissingEnglishTranslations() async {
    final mushroomsCollection =
        _db.collection(AppConstants.mushroomsCollection);
    final doppelgangersCollection =
        _db.collection(AppConstants.doppelgangersCollection);

    final mushroomSnapshot = await mushroomsCollection.get();
    final mushroomDocs = {
      for (final doc in mushroomSnapshot.docs) doc.id: doc,
    };
    final doppelgangerSnapshot = await doppelgangersCollection.get();

    final translationsByPair = <String, String>{
      for (final entry in _doppelgangers)
        '${entry['mushroomId']}|${entry['similarMushroomId']}':
            entry['differencesEn'] as String,
    };

    final batch = _db.batch();
    var operations = 0;

    for (final entry in _mushrooms) {
      final id = entry['id'] as String;
      final doc = mushroomDocs[id];
      if (doc == null) continue;

      final current = doc.data();
      final updates = <String, dynamic>{};

      for (final field in [
        'nameEn',
        'familyEn',
        'descriptionEn',
        'seasonEn',
        'habitatEn',
      ]) {
        final value = current[field];
        if (value is! String || value.trim().isEmpty) {
          updates[field] = entry[field];
        }
      }

      if (updates.isNotEmpty) {
        batch.update(doc.reference, updates);
        operations++;
      }
    }

    for (final doc in doppelgangerSnapshot.docs) {
      final current = doc.data();
      final key = '${current['mushroomId']}|${current['similarMushroomId']}';
      final translated = translationsByPair[key];
      if (translated == null) continue;

      final existing = current['differencesEn'];
      if (existing is! String || existing.trim().isEmpty) {
        batch.update(doc.reference, {'differencesEn': translated});
        operations++;
      }
    }

    if (operations > 0) {
      await batch.commit();
    }
  }

  static const List<Map<String, dynamic>> _mushrooms = [
    {
      'id': 'boletus_edulis',
      'nameRu': 'Белый гриб',
      'nameLatin': 'Boletus edulis',
      'family': 'Болетовые',
      'edibility': 'Edible',
      'description':
          'Один из самых ценных съедобных грибов. Шляпка коричневая, '
              'выпуклая, мякоть белая, не меняющая цвет на срезе. '
              'Трубчатый слой белый, затем желтоватый.',
      'season': 'Июнь — октябрь',
      'habitat': 'Хвойные и лиственные леса, около берёз, дубов и сосен',
      'nameEn': 'Porcini mushroom',
      'familyEn': 'Boletaceae',
      'descriptionEn':
          'A highly valued edible mushroom with a convex brown cap and white flesh that does not change color when cut. Its pore surface is initially white and later becomes yellowish.',
      'seasonEn': 'June – October',
      'habitatEn':
          'Coniferous and deciduous forests, often near birch, oak, and pine trees',
      'hasDoppelgangers': true,
    },
    {
      'id': 'amanita_phalloides',
      'nameRu': 'Бледная поганка',
      'nameLatin': 'Amanita phalloides',
      'family': 'Аманитовые',
      'edibility': 'DeadlyPoisonous',
      'description':
          'Смертельно ядовитый гриб. Шляпка зеленоватая или оливковая, '
              'есть кольцо на ножке и вольва (мешочек) у основания. '
              'Содержит аматоксины, поражающие печень.',
      'season': 'Июль — октябрь',
      'habitat': 'Лиственные леса, под дубами и буками',
      'nameEn': 'Death cap',
      'familyEn': 'Amanitaceae',
      'descriptionEn':
          'A deadly poisonous mushroom with a greenish or olive cap, a ring on the stem, and a sac-like volva at the base. It contains amatoxins that can cause severe liver damage.',
      'seasonEn': 'July – October',
      'habitatEn': 'Deciduous forests, especially near oak and beech trees',
      'hasDoppelgangers': true,
    },
    {
      'id': 'cantharellus_cibarius',
      'nameRu': 'Лисичка',
      'nameLatin': 'Cantharellus cibarius',
      'family': 'Лисичковые',
      'edibility': 'Edible',
      'description':
          'Жёлто-оранжевый гриб с волнистым краем шляпки. Вместо пластинок — '
              'складки, плавно переходящие на ножку. Редко червивеет.',
      'season': 'Июнь — октябрь',
      'habitat': 'Хвойные и смешанные леса, во мху',
      'nameEn': 'Chanterelle',
      'familyEn': 'Cantharellaceae',
      'descriptionEn':
          'A yellow-orange mushroom with a wavy cap margin. Instead of true gills, it has blunt ridges running down the stem. It is rarely infested with insects.',
      'seasonEn': 'June – October',
      'habitatEn': 'Coniferous and mixed forests, often among moss',
      'hasDoppelgangers': true,
    },
    {
      'id': 'amanita_muscaria',
      'nameRu': 'Мухомор красный',
      'nameLatin': 'Amanita muscaria',
      'family': 'Аманитовые',
      'edibility': 'Poisonous',
      'description': 'Ярко-красная шляпка с белыми хлопьями. Легко узнаваем. '
          'Ядовит, вызывает галлюцинации и отравление.',
      'season': 'Август — октябрь',
      'habitat': 'Хвойные и берёзовые леса',
      'nameEn': 'Fly agaric',
      'familyEn': 'Amanitaceae',
      'descriptionEn':
          'A distinctive mushroom with a bright red cap bearing white patches. It is poisonous and can cause serious intoxication and altered perception.',
      'seasonEn': 'August – October',
      'habitatEn': 'Coniferous and birch forests',
      'hasDoppelgangers': false,
    },
    {
      'id': 'leccinum_scabrum',
      'nameRu': 'Подберёзовик',
      'nameLatin': 'Leccinum scabrum',
      'family': 'Болетовые',
      'edibility': 'Edible',
      'description':
          'Серо-коричневая шляпка, ножка с тёмными чешуйками. Мякоть белая, '
              'на срезе почти не меняется. Хороший съедобный гриб.',
      'season': 'Июнь — октябрь',
      'habitat': 'Берёзовые и смешанные леса',
      'nameEn': 'Brown birch bolete',
      'familyEn': 'Boletaceae',
      'descriptionEn':
          'A bolete with a gray-brown cap and dark scabers on its stem. The flesh is white and usually changes little when cut.',
      'seasonEn': 'June – October',
      'habitatEn': 'Birch and mixed forests',
      'hasDoppelgangers': false,
    },
    {
      'id': 'leccinum_aurantiacum',
      'nameRu': 'Подосиновик',
      'nameLatin': 'Leccinum aurantiacum',
      'family': 'Болетовые',
      'edibility': 'Edible',
      'description':
          'Оранжево-красная шляпка, плотная ножка с чёрными чешуйками. '
              'Мякоть на срезе синеет, затем чернеет. Ценный съедобный гриб.',
      'season': 'Июнь — октябрь',
      'habitat': 'Осиновые и смешанные леса',
      'nameEn': 'Orange oak bolete',
      'familyEn': 'Boletaceae',
      'descriptionEn':
          'A bolete with an orange-red cap and a sturdy stem bearing dark scabers. The cut flesh may turn blue-gray and then darken.',
      'seasonEn': 'June – October',
      'habitatEn': 'Deciduous and mixed forests, including stands of aspen',
      'hasDoppelgangers': false,
    },
    {
      'id': 'lactarius_resimus',
      'nameRu': 'Груздь настоящий',
      'nameLatin': 'Lactarius resimus',
      'family': 'Сыроежковые',
      'edibility': 'ConditionallyEdible',
      'description': 'Белый гриб с воронковидной шляпкой и бахромчатым краем. '
          'Выделяет едкий млечный сок. Употребляется только после '
          'вымачивания и засолки.',
      'season': 'Июль — сентябрь',
      'habitat': 'Берёзовые и смешанные леса',
      'nameEn': 'Peppery milkcap',
      'familyEn': 'Russulaceae',
      'descriptionEn':
          'A pale milkcap with a funnel-shaped cap and a fringed margin. It releases strongly acrid milky latex. Traditionally prepared only after extensive soaking and salting; do not treat this description as proof of safety.',
      'seasonEn': 'July – September',
      'habitatEn': 'Birch and mixed forests',
      'hasDoppelgangers': false,
    },
    {
      'id': 'armillaria_mellea',
      'nameRu': 'Опёнок осенний',
      'nameLatin': 'Armillaria mellea',
      'family': 'Физалакриевые',
      'edibility': 'Edible',
      'description':
          'Растёт большими группами на пнях и стволах. Шляпка медово-жёлтая '
              'с чешуйками, на ножке есть кольцо. Съедобен после '
              'термообработки.',
      'season': 'Август — ноябрь',
      'habitat': 'На пнях, валежнике и живых деревьях',
      'nameEn': 'Honey fungus',
      'familyEn': 'Physalacriaceae',
      'descriptionEn':
          'Grows in groups on stumps and trees. It has a honey-colored cap, sometimes with scales, and a ring on the stem. May cause gastrointestinal illness if inadequately cooked and must not be confused with deadly lookalikes.',
      'seasonEn': 'August – November',
      'habitatEn': 'Stumps, fallen wood, and living trees',
      'hasDoppelgangers': true,
    },
    {
      'id': 'galerina_marginata',
      'nameRu': 'Галерина окаймлённая',
      'nameLatin': 'Galerina marginata',
      'family': 'Строфариевые',
      'edibility': 'DeadlyPoisonous',
      'description':
          'Мелкий коричневый гриб, растущий на древесине. Смертельно ядовит — '
              'содержит те же токсины, что и бледная поганка. Опасный двойник '
              'опят.',
      'season': 'Август — ноябрь',
      'habitat': 'На гниющей древесине хвойных и лиственных пород',
      'nameEn': 'Funeral bell',
      'familyEn': 'Hymenogastraceae',
      'descriptionEn':
          'A small brown wood-growing mushroom. Deadly poisonous: it contains amatoxins like those found in the death cap. It can be confused with honey fungi and other wood-growing species.',
      'seasonEn': 'August – November',
      'habitatEn': 'Decaying coniferous and deciduous wood',
      'hasDoppelgangers': true,
    },
    {
      'id': 'agaricus_campestris',
      'nameRu': 'Шампиньон обыкновенный',
      'nameLatin': 'Agaricus campestris',
      'family': 'Шампиньоновые',
      'edibility': 'Edible',
      'description':
          'Белая шляпка, пластинки от розовых до тёмно-коричневых. На ножке '
              'кольцо. Распространённый съедобный гриб. Важно отличать от '
              'бледной поганки.',
      'season': 'Май — октябрь',
      'habitat': 'Луга, поля, пастбища, сады',
      'nameEn': 'Field mushroom',
      'familyEn': 'Agaricaceae',
      'descriptionEn':
          'A white-capped mushroom with gills that turn from pink to dark brown and a ring on the stem. Careful identification is essential because deadly Amanita species can look similar.',
      'seasonEn': 'May – October',
      'habitatEn': 'Meadows, fields, pastures, and gardens',
      'hasDoppelgangers': true,
    },
    {
      'id': 'tylopilus_felleus',
      'nameRu': 'Жёлчный гриб',
      'nameLatin': 'Tylopilus felleus',
      'family': 'Болетовые',
      'edibility': 'Inedible',
      'description':
          'Несъедобный гриб-двойник белого. Шляпка коричневая, трубчатый '
              'слой розовеет с возрастом, на ножке заметна тёмная сеточка. '
              'Мякоть на срезе слегка розовеет. Очень горький — портит блюдо.',
      'season': 'Июнь — октябрь',
      'habitat': 'Хвойные и смешанные леса, на кислых почвах',
      'nameEn': 'Bitter bolete',
      'familyEn': 'Boletaceae',
      'descriptionEn':
          'An inedible lookalike of porcini with a brown cap, pores that become pinkish with age, and a prominent dark network on the stem. Its extremely bitter flesh can spoil a dish.',
      'seasonEn': 'June – October',
      'habitatEn': 'Coniferous and mixed forests, especially on acidic soils',
      'hasDoppelgangers': true,
    },
  ];

  static const List<Map<String, dynamic>> _doppelgangers = [
    {
      'mushroomId': 'agaricus_campestris',
      'similarMushroomId': 'amanita_phalloides',
      'differences':
          'У шампиньона пластинки розовеют, а затем темнеют; нет вольвы у '
              'основания. У бледной поганки пластинки всегда белые и есть '
              'вольва (мешочек).',
      'differencesEn':
          'Field mushroom gills start pink and become dark brown, and it lacks a volva at the stem base. Death cap gills remain white, and a sac-like volva is present. Never rely on a single feature for identification.',
    },
    {
      'mushroomId': 'amanita_phalloides',
      'similarMushroomId': 'agaricus_campestris',
      'differences':
          'Бледная поганка имеет белые пластинки и вольву; шампиньон — '
              'розовеющие пластинки без вольвы.',
      'differencesEn':
          'Death caps have white gills and a volva at the stem base. Field mushrooms have gills that turn pink and then brown, without a volva. Death caps are deadly poisonous.',
    },
    {
      'mushroomId': 'armillaria_mellea',
      'similarMushroomId': 'galerina_marginata',
      'differences':
          'У осеннего опёнка плотная мякоть, кольцо и чешуйки на шляпке. '
              'Галерина мельче, без чешуек, смертельно ядовита.',
      'differencesEn':
          'Honey fungus can have a ring and cap scales. Funeral bell is often smaller and can have a smooth cap; it is deadly poisonous. These features alone cannot ensure a safe identification.',
    },
    {
      'mushroomId': 'galerina_marginata',
      'similarMushroomId': 'armillaria_mellea',
      'differences':
          'Галерина — мелкий гриб с гладкой шляпкой, растущий на древесине; '
              'смертельно ядовита. Опёнок крупнее, со чешуйками.',
      'differencesEn':
          'Funeral bell is a deadly poisonous small brown mushroom growing on wood. Honey fungus often forms larger clusters and may have cap scales; these traits can overlap.',
    },
    {
      'mushroomId': 'boletus_edulis',
      'similarMushroomId': 'amanita_phalloides',
      'differences':
          'У белого гриба трубчатый (губчатый) слой под шляпкой и нет '
              'кольца/вольвы. У бледной поганки пластинки и есть вольва.',
      'differencesEn':
          'Porcini has pores under the cap, rather than gills, and lacks the ring and volva characteristic of death cap. Death cap has white gills and a volva and is deadly poisonous.',
    },
    {
      'mushroomId': 'cantharellus_cibarius',
      'similarMushroomId': 'amanita_muscaria',
      'differences':
          'У лисички складки вместо пластинок и однородный жёлтый цвет. '
              'Ложные двойники имеют ровные пластинки и более яркую окраску.',
      'differencesEn':
          'Chanterelles have blunt, forked ridges rather than true gills and are usually yellow. Other lookalikes may have true gills and a brighter orange color. These features do not replace expert identification.',
    },
    {
      'mushroomId': 'boletus_edulis',
      'similarMushroomId': 'tylopilus_felleus',
      'differences':
          'У белого гриба трубчатый слой белый/желтоватый, мякоть не горчит, '
              'сеточка на ножке светлая. У жёлчного гриба трубочки розовеют, '
              'сеточка тёмная, мякоть очень горькая.',
      'differencesEn':
          'Porcini has a whitish to yellowish pore surface and a paler stem network. Bitter bolete develops pinkish pores, has a darker stem network, and is extremely bitter. Do not taste unknown mushrooms.',
    },
    {
      'mushroomId': 'tylopilus_felleus',
      'similarMushroomId': 'boletus_edulis',
      'differences':
          'Жёлчный гриб горький, с тёмной сеточкой и розовеющими трубочками. '
              'Белый гриб не горчит, трубчатый слой остаётся светлым.',
      'differencesEn':
          'Bitter bolete develops pinkish pores and a prominent dark stem network, unlike the typically pale pores and lighter network of porcini. Do not taste an unknown mushroom to identify it.',
    },
  ];

  static const List<Map<String, dynamic>> _images = [
    {
      'mushroomId': 'boletus_edulis',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/'
          'Bolete-Boletus_edulis.jpg/640px-Bolete-Boletus_edulis.jpg',
      'description': 'Плодовое тело белого гриба',
    },
    {
      'mushroomId': 'amanita_phalloides',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/'
          'Amanita_phalloides_1.JPG/640px-Amanita_phalloides_1.JPG',
      'description': 'Бледная поганка с вольвой',
    },
    {
      'mushroomId': 'cantharellus_cibarius',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/'
          'Cantharellus_cibarius_2009_G1.jpg/'
          '640px-Cantharellus_cibarius_2009_G1.jpg',
      'description': 'Лисичка обыкновенная',
    },
    {
      'mushroomId': 'amanita_muscaria',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/'
          'Amanita_muscaria_3_vliegenzwammen_op_rij.jpg/'
          '640px-Amanita_muscaria_3_vliegenzwammen_op_rij.jpg',
      'description': 'Мухомор красный',
    },
    {
      'mushroomId': 'leccinum_scabrum',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/'
          'Leccinum_scabrum_2.jpg/640px-Leccinum_scabrum_2.jpg',
      'description': 'Подберёзовик обыкновенный',
    },
    {
      'mushroomId': 'leccinum_aurantiacum',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/'
          'Leccinum_aurantiacum_01.jpg/640px-Leccinum_aurantiacum_01.jpg',
      'description': 'Подосиновик красный',
    },
    {
      'mushroomId': 'lactarius_resimus',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/'
          'Lactarius_resimus.jpg/640px-Lactarius_resimus.jpg',
      'description': 'Груздь настоящий',
    },
    {
      'mushroomId': 'armillaria_mellea',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/'
          'Armillaria_mellea_JPG1.jpg/640px-Armillaria_mellea_JPG1.jpg',
      'description': 'Опёнок осенний на пне',
    },
    {
      'mushroomId': 'galerina_marginata',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/'
          'Galerina_marginata_60376.jpg/640px-Galerina_marginata_60376.jpg',
      'description': 'Галерина окаймлённая',
    },
    {
      'mushroomId': 'agaricus_campestris',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/'
          'Agaricus_campestris_2009_G1.jpg/'
          '640px-Agaricus_campestris_2009_G1.jpg',
      'description': 'Шампиньон обыкновенный',
    },
    {
      'mushroomId': 'tylopilus_felleus',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/'
          'Tylopilus_felleus_2.jpg/640px-Tylopilus_felleus_2.jpg',
      'description': 'Жёлчный гриб',
    },
  ];
}
