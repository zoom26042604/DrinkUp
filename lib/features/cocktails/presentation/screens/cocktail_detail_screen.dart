import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cocktail_providers.dart';

class CocktailDetailScreen extends ConsumerWidget {
  final String id;

  const CocktailDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cocktailAsync = ref.watch(cocktailDetailProvider(id));
    final isFav = ref.watch(
      favoritesProvider
          .select((s) => s.valueOrNull?.any((c) => c.id == id) ?? false),
    );

    return Scaffold(
      body: cocktailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (cocktail) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white),
                  onPressed: () =>
                      ref.read(favoritesProvider.notifier).toggle(cocktail),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  cocktail.name,
                  style: const TextStyle(
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
                background: Hero(
                  tag: 'cocktail-${cocktail.id}',
                  child: CachedNetworkImage(
                    imageUrl: '${cocktail.thumbnailUrl}/medium',
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) =>
                        const ColoredBox(color: Color(0xFFE0E0E0)),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        if (cocktail.category != null)
                          Chip(label: Text(cocktail.category!)),
                        Chip(
                          label: Text(
                              cocktail.isAlcoholic ? 'Alcoolisé' : 'Sans alcool'),
                          backgroundColor: cocktail.isAlcoholic
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                        ),
                        if (cocktail.glassType != null)
                          Chip(label: Text(cocktail.glassType!)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Ingrédients',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...cocktail.ingredients.map(
                      (ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Image.network(
                              ing.imageSmallUrl,
                              width: 32,
                              height: 32,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.circle, size: 8),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(ing.name)),
                            if (ing.measure != null)
                              Text(ing.measure!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    if (cocktail.instructions != null) ...[
                      const SizedBox(height: 16),
                      Text('Préparation',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(cocktail.instructions!),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
