import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class MovieCardBanner extends StatelessWidget {
  final String url;

  const MovieCardBanner({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              color: ColorTheme.surfaceVariant,
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorTheme.buttonPrimary,
                  ),
                ),
              ),
            ),
      errorBuilder: (_, _, _) => Container(
        color: ColorTheme.surfaceVariant,
        child: const Icon(
          Icons.movie_outlined,
          color: ColorTheme.textSecondary,
          size: 36,
        ),
      ),
    );
  }
}
