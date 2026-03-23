import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../providers/game_favorites_provider.dart';
import '../providers/game_providers.dart';
import '../providers/nav_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/game_result_card.dart';

class IsItInMyCocktailScreen extends ConsumerWidget {
  const IsItInMyCocktailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final gameAsync = ref.watch(game3Provider);
    final notifier = ref.read(game3Provider.notifier);

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
        extendBody: true,
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: (i) {
            ref.read(navIndexProvider.notifier).state = i;
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: gameAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.noir),
            ),
            error: (_, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Something went wrong',
                      style: TextStyle(color: AppColors.noir)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(game3Provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rose,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (s) => SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 150),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.noir),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          ref.watch(gameFavoritesProvider).contains(2)
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: ref.watch(gameFavoritesProvider).contains(2)
                              ? AppColors.rose
                              : AppColors.noir,
                          size: 28,
                        ),
                        onPressed: () =>
                            ref.read(gameFavoritesProvider.notifier).toggle(2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Is it in my cocktail ?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Sort the ingredients of a ${s.cocktail.name} !',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.noir),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Drag each chip into the correct zone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.noir.withValues(alpha: 0.55),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (s.available.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.beige.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: AppColors.noir, width: 1.5),
                        ),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: s.available
                              .map((ing) => _DraggableChip(
                                    text: ing,
                                    onReturn: null,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  if (s.available.isEmpty && !s.gameOver)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'All placed ! Tap VALIDATE to check.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.noir.withValues(alpha: 0.65),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DragTarget<String>(
                            onAcceptWithDetails: (d) =>
                                notifier.dropToIn(d.data),
                            builder: (_, candidate, _) => _DropZoneWidget(
                              label: 'In ✓',
                              color: candidate.isNotEmpty
                                  ? AppColors.rose.withValues(alpha: 0.35)
                                  : AppColors.beige.withValues(alpha: 0.75),
                              borderColor: candidate.isNotEmpty
                                  ? AppColors.rose
                                  : AppColors.noir,
                              ingredients: s.inZone,
                              onChipTap: s.gameOver
                                  ? null
                                  : notifier.returnToAvailable,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DragTarget<String>(
                            onAcceptWithDetails: (d) =>
                                notifier.dropToNotIn(d.data),
                            builder: (_, candidate, _) => _DropZoneWidget(
                              label: 'Not in ✗',
                              color: candidate.isNotEmpty
                                  ? AppColors.rose.withValues(alpha: 0.35)
                                  : AppColors.beigeFonce
                                      .withValues(alpha: 0.75),
                              borderColor: candidate.isNotEmpty
                                  ? AppColors.rose
                                  : AppColors.noir,
                              ingredients: s.notInZone,
                              onChipTap: s.gameOver
                                  ? null
                                  : notifier.returnToAvailable,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (s.gameOver)
                    GameResultCard(
                      won: s.won,
                      title: s.won ? 'Perfect!' : 'Wrong...',
                      detail: s.won
                          ? 'You sorted the ${s.cocktail.name} ingredients correctly!'
                          : 'The real ingredients were:\n${s.realIngredients.join(', ')}\n\n${gameGage(s.cocktail.name)}',
                      onPlayAgain: () => notifier.restart(),
                    ),
                  if (!s.gameOver) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: s.allPlaced ? () => notifier.validate() : null,
                        child: Opacity(
                          opacity: s.allPlaced ? 1.0 : 0.45,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.rose, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26, blurRadius: 10),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'VALIDATE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.noir,
                                ),
                              ),
                            ),
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
      ),
    );
  }
}

class _DraggableChip extends StatelessWidget {
  final String text;
  final VoidCallback? onReturn;

  const _DraggableChip({required this.text, this.onReturn});

  @override
  Widget build(BuildContext context) {
    final chip = _Chip(text: text);
    return Draggable<String>(
      data: text,
      feedback: Material(
        color: Colors.transparent,
        child: _Chip(text: text, elevated: true),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: chip),
      child: onReturn != null
          ? GestureDetector(onTap: onReturn, child: chip)
          : chip,
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool elevated;

  const _Chip({required this.text, this.elevated = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.noir, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: elevated ? 0.25 : 0.12),
            blurRadius: elevated ? 10 : 4,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.noir,
        ),
      ),
    );
  }
}

class _DropZoneWidget extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final List<String> ingredients;
  final void Function(String)? onChipTap;

  const _DropZoneWidget({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.ingredients,
    this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
          ),
          const SizedBox(height: 10),
          if (ingredients.isEmpty)
            Text(
              'Drop here',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.noir.withValues(alpha: 0.4),
                fontStyle: FontStyle.italic,
              ),
            ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: ingredients
                .map((ing) => _DraggableChip(
                      text: ing,
                      onReturn:
                          onChipTap != null ? () => onChipTap!(ing) : null,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
