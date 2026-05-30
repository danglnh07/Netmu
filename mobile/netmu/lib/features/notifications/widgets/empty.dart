import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: ColorTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 30,
              color: ColorTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ColorTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "You're all caught up. Check back later.",
            style: TextStyle(
              fontSize: 14,
              color: ColorTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}