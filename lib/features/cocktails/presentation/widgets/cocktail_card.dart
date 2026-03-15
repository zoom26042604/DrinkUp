import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/cocktail.dart';
import '../providers/cocktail_providers.dart';

class CocktailCard extends ConsumerWidget {
  final Cocktail cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select(
        (state) => state.valueOrNull?.any((c) => c.id == cocktail.id) ?? false,
      ),
    );

    return GestureDetector(
      onTap: () => context.push('/cocktail/${cocktail.id}'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'cocktail-${cocktail.id}',
                child: CachedNetworkImage(
                  imageUrl: '${cocktail.thumbnailUrl}/medium',
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, _, _) => const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Icon(Icons.local_bar, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cocktail.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () =>
                        ref.read(favoritesProvider.notifier).toggle(cocktail),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
