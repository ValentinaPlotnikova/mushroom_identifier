import 'package:flutter/material.dart';

import '../core/constants.dart';

class StatusBadge extends StatelessWidget {
  final IdentificationStatus status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  static Color colorFor(IdentificationStatus status) {
    switch (status) {
      case IdentificationStatus.determined:
        return const Color(0xFF2E7D32);
      case IdentificationStatus.needsCheck:
        return const Color(0xFFEF6C00);
      case IdentificationStatus.notDetermined:
        return const Color(0xFF757575);
    }
  }

  static IconData iconFor(IdentificationStatus status) {
    switch (status) {
      case IdentificationStatus.determined:
        return Icons.verified;
      case IdentificationStatus.needsCheck:
        return Icons.help_outline;
      case IdentificationStatus.notDetermined:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorFor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconFor(status), color: Colors.white, size: compact ? 13 : 15),
          const SizedBox(width: 4),
          Text(
            status.labelRu,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
