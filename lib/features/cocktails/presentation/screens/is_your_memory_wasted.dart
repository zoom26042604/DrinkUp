import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/nav_provider.dart';

class IsYourMemoryWastedScreen extends ConsumerStatefulWidget {
  const IsYourMemoryWastedScreen({super.key});

  @override
  ConsumerState<IsYourMemoryWastedScreen> createState() =>
      _IsYourMemoryWastedScreenState();
}

class _IsYourMemoryWastedScreenState
    extends ConsumerState<IsYourMemoryWastedScreen> {

  final List<String> _cards = [
    'Menthe', 'Mojito', 'Tequila', 'Margarita',
    'Cranberry', 'Cosmopolitan', 'Lait de coco', 'Piña Colada',
    'Eau gazeuse', 'Mojito', 'Triple sec', 'Cosmopolitan',
    'Citron vert', 'Margarita', 'Peach Schnapps', 'Sex on the Beach',
  ];

  final List<int> _cardState = [
    0, 0, 1, 0,
    0, 2, 0, 2,
    0, 0, 1, 0,
    0, 0, 0, 0,
  ];

  final int _moves = 4;
  final int _matchedCount = 2;
  final int _totalPairs = 8;
  final bool _gameOver = false;

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) {
          ref.read(navIndexProvider.notifier).state = i;
          Navigator.pop(context);
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.beigeFonce, AppColors.rose],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.noir),
                  onPressed: () => Navigator.pop(context),
                ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.noir, width: 1.5),
                      ),
                      child: Text(
                        'Moves : $_moves',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.noir,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.rose, width: 1.5),
                      ),
                      child: Text(
                        '$_matchedCount / $_totalPairs',
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (_, i) {
                      final state = _cardState[i];
                      if (state == 2) return _MatchedCard(text: _cards[i]);
                      if (state == 1) return _FlippedCard(text: _cards[i]);
                      return const _HiddenCard();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (_gameOver)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.rose.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.rose, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🎉 Your memory is intact !',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.noir,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Finished in $_moves moves',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.noir,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.beige,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.beige, width: 2),
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
            ],
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
        color: AppColors.rose.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.rose, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.rose,
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
        border: Border.all(color: AppColors.noir, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
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
        color: AppColors.rose.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.rose, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.rose,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
