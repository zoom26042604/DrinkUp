import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../providers/game_favorites_provider.dart';
import '../providers/game_providers.dart';
import '../providers/nav_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/game_result_card.dart';

class GuessDemonLiquidScreen extends ConsumerStatefulWidget {
  const GuessDemonLiquidScreen({super.key});

  @override
  ConsumerState<GuessDemonLiquidScreen> createState() =>
      _GuessDemonLiquidScreenState();
}

class _GuessDemonLiquidScreenState
    extends ConsumerState<GuessDemonLiquidScreen> {
  TextEditingController? _fieldController;
  List<String> _ingredientCache = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ingredientNamesProvider.future).then((names) {
        if (mounted) setState(() => _ingredientCache = names);
      });
    });
  }

  void _onValidate() {
    final text = _fieldController?.text.trim() ?? '';
    if (text.isEmpty) return;
    ref.read(game2Provider.notifier).validate(text);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navIndexProvider);
    final gameAsync = ref.watch(game2Provider);

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
                    onPressed: () => ref.invalidate(game2Provider),
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
                          ref.watch(gameFavoritesProvider).contains(1)
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: ref.watch(gameFavoritesProvider).contains(1)
                              ? AppColors.rose
                              : AppColors.noir,
                          size: 28,
                        ),
                        onPressed: () =>
                            ref.read(gameFavoritesProvider.notifier).toggle(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Guess My Demon Liquid !',
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
                      'Find the alcohol hidden in this cocktail !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.noir),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.rose, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: s.cocktail.thumbnailUrl,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.rose.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.rose),
                                ),
                              ),
                              errorWidget: (_, _, _) => Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.rose.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.local_bar,
                                    size: 80, color: AppColors.rose),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            s.cocktail.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.noir,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (s.gameOver)
                    GameResultCard(
                      won: s.won,
                      title: s.won ? 'Well done!' : 'Too bad...',
                      detail: s.won
                          ? 'You found the alcohol!'
                          : 'This cocktail contained:\n${s.cocktail.ingredients.map((i) => i.name).join(', ')}\n\n${gameGage(s.cocktail.name)}',
                      onPlayAgain: () {
                        _fieldController?.clear();
                        ref.read(game2Provider.notifier).restart();
                      },
                    ),
                  if (!s.gameOver) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Autocomplete<String>(
                        optionsBuilder: (textValue) {
                          final q = textValue.text.trim();
                          if (q.isEmpty || _ingredientCache.isEmpty) {
                            return const [];
                          }
                          return _ingredientCache
                              .where((n) => n
                                  .toLowerCase()
                                  .contains(q.toLowerCase()))
                              .take(8);
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
                            decoration:
                                _inputDecoration('Type an alcohol name...'),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
