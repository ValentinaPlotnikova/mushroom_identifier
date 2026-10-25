
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MushroomPhoto extends StatelessWidget {
  final String? imageUrl;
  final double height;

  const MushroomPhoto({
    super.key,
    required this.imageUrl,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: height,
          color: const Color(0xFFE8F5E9),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 48,
        color: Color(0xFF2E7D32),
      ),
    );
  }
}
