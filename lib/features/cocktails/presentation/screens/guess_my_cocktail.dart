import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../providers/game_favorites_provider.dart';
import '../providers/game_providers.dart';
import '../providers/nav_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/game_result_card.dart';

class GuessMyCocktailScreen extends ConsumerStatefulWidget {
  const GuessMyCocktailScreen({super.key});

  @override
  ConsumerState<GuessMyCocktailScreen> createState() =>
      _GuessMyCocktailScreenState();
}

class _GuessMyCocktailScreenState
    extends ConsumerState<GuessMyCocktailScreen> {
  TextEditingController? _fieldController;

  void _onValidate() {
    final text = _fieldController?.text.trim() ?? '';
    if (text.isEmpty) return;
    ref.read(game1Provider.notifier).validate(text);
    final s = ref.read(game1Provider).valueOrNull;
    if (s != null && !s.gameOver) _fieldController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navIndexProvider);
    final gameAsync = ref.watch(game1Provider);

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
                    onPressed: () => ref.invalidate(game1Provider),
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
                          ref.watch(gameFavoritesProvider).contains(0)
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: ref.watch(gameFavoritesProvider).contains(0)
                              ? AppColors.rose
                              : AppColors.noir,
                          size: 28,
                        ),
                        onPressed: () =>
                            ref.read(gameFavoritesProvider.notifier).toggle(0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Guess My Cocktail !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Guess the cocktail from its revealed ingredients !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.noir),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const spacing = 8.0;
                        const maxPerRow = 4;
                        final count = s.cocktail.ingredients.length;
                        final perRow = count <= maxPerRow ? count : maxPerRow;
                        final cardWidth = (constraints.maxWidth - spacing * (perRow - 1)) / perRow;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          alignment: WrapAlignment.center,
                          children: List.generate(count, (i) {
                            final isRevealed = i < s.revealedCount;
                            return SizedBox(
                              width: cardWidth,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: isRevealed
                                    ? _IngredientCard(
                                        key: ValueKey('revealed_$i'),
                                        text: s.cocktail.ingredients[i].name,
                                      )
                                    : _HiddenCard(key: ValueKey('hidden_$i')),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${s.cocktail.ingredients.length - s.revealedCount} hint(s) remaining',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.noir.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (s.gameOver)
                    GameResultCard(
                      won: s.won,
                      title: s.won ? 'Well done!' : 'Too bad...',
                      detail: s.won
                          ? 'It was indeed ${s.cocktail.name}!'
                          : 'It was: ${s.cocktail.name}\n${gameGage(s.cocktail.name)}',
                      scoreWidget: s.won
                          ? buildStarScore(
                              s.score, s.cocktail.ingredients.length)
                          : null,
                      onPlayAgain: () {
                        _fieldController?.clear();
                        ref.read(game1Provider.notifier).restart();
                      },
                    ),
                  if (!s.gameOver) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Autocomplete<String>(
                        optionsBuilder: (textValue) async {
                          final q = textValue.text.trim();
                          if (q.isEmpty) return const [];
                          try {
                            final letter = q[0].toUpperCase();
                            final names = await ref.read(
                                cocktailNamesByLetterProvider(letter).future);
                            return names
                                .where((n) => n
                                    .toLowerCase()
                                    .contains(q.toLowerCase()))
                                .take(8);
                          } catch (_) {
                            return const [];
                          }
                        },
                        onSelected: (_) => _onValidate(),
                        optionsViewBuilder: _optionsView,
                        fieldViewBuilder:
                            (ctx, controller, focusNode, onSubmit) {
                          _fieldController = controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.noir,
                            ),
                            onSubmitted: (_) => _onValidate(),
                            decoration: _inputDecoration(
                                'Type a cocktail name...'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    _ActionButton(label: 'VALIDATE', onTap: _onValidate),
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

Widget _optionsView(
  BuildContext context,
  AutocompleteOnSelected<String> onSelected,
  Iterable<String> options,
) {
  return Align(
    alignment: Alignment.topLeft,
    child: Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: AppColors.beige,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: options.length > 6 ? 6 : options.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, color: AppColors.beigeFonce),
        itemBuilder: (_, i) {
          final option = options.elementAt(i);
          return InkWell(
            onTap: () => onSelected(option),
            borderRadius: BorderRadius.vertical(
              top: i == 0 ? const Radius.circular(12) : Radius.zero,
              bottom: i == options.length - 1
                  ? const Radius.circular(12)
                  : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Text(
                option,
                style: const TextStyle(
                  color: AppColors.noir,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.noir.withValues(alpha: 0.4)),
      filled: true,
      fillColor: AppColors.beige,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.rose, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.rose, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.noir, width: 2),
      ),
    );

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.beige,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.rose, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 10),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  final String text;
  const _IngredientCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.noir, width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _HiddenCard extends StatelessWidget {
  const _HiddenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.noir.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.noir, width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.noir,
          ),
        ),
      ),
    );
  }
}
