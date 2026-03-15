import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cocktail_providers.dart';
import '../widgets/cocktail_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _letters = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLetter = ref.watch(selectedLetterProvider);
    final cocktailsAsync = ref.watch(cocktailsByLetterProvider(selectedLetter));

    return Scaffold(
      appBar: AppBar(title: const Text('DrinkUp')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _letters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, index) {
                final letter = _letters[index];
                final isSelected = letter == selectedLetter;
                return ChoiceChip(
                  label: Text(letter.toUpperCase()),
                  selected: isSelected,
                  onSelected: (_) => ref
                      .read(selectedLetterProvider.notifier)
                      .state = letter,
                );
              },
            ),
          ),
          Expanded(
            child: cocktailsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 8),
                    Text('$error'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(
                        cocktailsByLetterProvider(selectedLetter),
                      ),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
              data: (cocktails) => GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width >= 600 ? 3 : 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cocktails.length,
                itemBuilder: (_, index) =>
                    CocktailCard(cocktail: cocktails[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
