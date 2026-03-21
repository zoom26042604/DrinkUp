import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../providers/game_favorites_provider.dart';
import '../providers/game_providers.dart';
import '../providers/nav_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/game_result_card.dart';

class IsYourMemoryWastedScreen extends ConsumerWidget {
  const IsYourMemoryWastedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    final gameAsync = ref.watch(game4Provider);
    final notifier = ref.read(game4Provider.notifier);

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
                    onPressed: () => ref.invalidate(game4Provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rose,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (s) => Column(
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
                        ref.watch(gameFavoritesProvider).contains(3)
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: ref.watch(gameFavoritesProvider).contains(3)
                            ? AppColors.rose
                            : AppColors.noir,
                        size: 28,
                      ),
                      onPressed: () =>
                          ref.read(gameFavoritesProvider.notifier).toggle(3),
                    ),
                  ],
                ),
                const Text(
                  'Is your memory wasted ?',
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
                    'Match each ingredient with its cocktail !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.noir),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.beige,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.noir, width: 1.5),
                        ),
                        child: Text(
                          'Moves : ${s.moves}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.noir,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.beige,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.rose, width: 1.5),
                        ),
                        child: Text(
                          '${s.matchedPairs} / ${s.totalPairs}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.noir,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: s.cards.length,
                      itemBuilder: (_, i) {
                        final card = s.cards[i];
                        return GestureDetector(
                          onTap: s.isLocked
                              ? null
                              : () => notifier.flipCard(i),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: switch (card.state) {
                              CardState.matched => _MatchedCard(
                                  key: ValueKey('m_$i'),
                                  text: card.text,
                                ),
                              CardState.flipped => _FlippedCard(
                                  key: ValueKey('f_$i'),
                                  text: card.text,
                                ),
                              CardState.hidden => _HiddenCard(
                                  key: ValueKey('h_$i'),
                                ),
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (s.gameOver)
                  GameResultCard(
                    won: true,
                    title: 'Memory intact!',
                    detail: 'Finished in ${s.moves} move(s)',
                    scoreWidget: buildMoveStars(s.moves, s.totalPairs),
                    onPlayAgain: () => notifier.restart(),
                  ),
                if (!s.gameOver)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: GestureDetector(
                      onTap: () => notifier.restart(),
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
                        child: const Center(
                          child: Text(
                            'RESTART',
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
              ],
            ),
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
      decoration: BoxDecoration(
        color: AppColors.noir.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.rose, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.noir,
          ),
        ),
      ),
    );
  }
}

class _FlippedCard extends StatelessWidget {
  final String text;
  const _FlippedCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.rose, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
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

class _MatchedCard extends StatelessWidget {
  final String text;
  const _MatchedCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.rose,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.noir, width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
