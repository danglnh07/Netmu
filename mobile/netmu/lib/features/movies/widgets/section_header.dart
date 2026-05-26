import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  // final VoidCallback onSeeAll;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ColorTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          // GestureDetector(
          //   onTap: onSeeAll,
          //   child: const Text(
          //     'See all',
          //     style: TextStyle(
          //       fontSize: 13,
          //       fontWeight: FontWeight.w500,
          //       color: ColorTheme.buttonPrimary,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}