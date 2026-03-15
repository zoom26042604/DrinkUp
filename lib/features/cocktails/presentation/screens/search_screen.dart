import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cocktail_providers.dart';
import '../widgets/cocktail_card.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              hintText: 'Nom du cocktail...',
              leading: const Icon(Icons.search),
              trailing: [
                if (query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () =>
                        ref.read(searchQueryProvider.notifier).state = '',
                  ),
              ],
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: query.trim().isEmpty
                ? const Center(child: Text('Entrez un nom de cocktail'))
                : resultsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('$error')),
                    data: (cocktails) => cocktails.isEmpty
                        ? const Center(child: Text('Aucun résultat'))
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width >= 600
                                      ? 3
                                      : 2,
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
