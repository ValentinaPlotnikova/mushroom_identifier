class MushroomImage {
  final String id;
  final String mushroomId;
  final String imageUrl;
  final String description;

  const MushroomImage({
    required this.id,
    required this.mushroomId,
    required this.imageUrl,
    this.description = '',
  });

  factory MushroomImage.fromMap(String id, Map<String, dynamic> map) {
    return MushroomImage(
      id: id,
      mushroomId: map['mushroomId'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mushroomId': mushroomId,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
