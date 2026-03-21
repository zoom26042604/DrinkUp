import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../../domain/entities/cocktail.dart';
import '../providers/cocktail_providers.dart';

class CocktailDetailScreen extends ConsumerWidget {
  final Cocktail cocktail;

  const CocktailDetailScreen({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).valueOrNull?.any((c) => c.id == cocktail.id) ?? false;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.beigeFonce, AppColors.rose],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.noir),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: isFav ? AppColors.rose : AppColors.noir,
                          size: 26,
                        ),
                        onPressed: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(cocktail),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: cocktail.thumbnailUrl,
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        width: 220,
                        height: 220,
                        color: AppColors.rose.withValues(alpha: 0.2),
                        child: const Center(
                          child:
                              CircularProgressIndicator(color: AppColors.rose),
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        width: 220,
                        height: 220,
                        color: AppColors.rose.withValues(alpha: 0.2),
                        child: const Icon(Icons.local_bar,
                            size: 80, color: AppColors.rose),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    cocktail.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (cocktail.category != null)
                        _Badge(cocktail.category!),
                      if (cocktail.glassType != null)
                        _Badge(cocktail.glassType!),
                      _Badge(
                          cocktail.isAlcoholic ? 'Alcoholic' : 'Non-alcoholic'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Ingredients',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cocktail.ingredients
                        .map(
                          (ing) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: AppColors.rose, width: 1.5),
                            ),
                            child: Text(
                              ing.measure != null
                                  ? '${ing.measure} ${ing.name}'
                                  : ing.name,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.noir,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (cocktail.instructions != null) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.noir,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.rose, width: 1.5),
                      ),
                      child: Text(
                        cocktail.instructions!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.noir,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.noir,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
