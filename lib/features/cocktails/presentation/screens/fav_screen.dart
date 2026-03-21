import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/speech_bubble.dart';
import 'guess_demon_liquid_screen.dart';
import 'guess_my_cocktail.dart';
import 'is_it_in_my_cocktail.dart';
import 'is_your_memory_wasted.dart';

class _GameEntry {
  final String titre;
  final String desc;
  final Widget screen;
  const _GameEntry({required this.titre, required this.desc, required this.screen});
}

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  static final _favGames = [
    _GameEntry(titre: 'Guess My Cocktail', desc: 'Ingredients are revealed one by one — name the cocktail before they run out!', screen: const GuessMyCocktailScreen()),
    _GameEntry(titre: 'Guess My Demon Liquid', desc: 'You see the cocktail, now find the alcohol hiding inside!', screen: const GuessDemonLiquidScreen()),
    _GameEntry(titre: 'Is It In My Cocktail?', desc: 'Drag and drop ingredients to sort what is in the cocktail and what is not!', screen: const IsItInMyCocktailScreen()),
    _GameEntry(titre: 'Is Your Memory Wasted?', desc: 'Flip cards and match cocktail pairs before your memory gives up!', screen: const IsYourMemoryWastedScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            const SizedBox(height: 60),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Here is our top picks for the best drinking games to spice up your nights!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.noir,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 20,
                    left: 24,
                    right: 24,
                    child: SpeechBubble(
                      text: 'Our favorite games, only for you!',
                    ),
                  ),
                  Positioned(
                    bottom: -270,
                    right: -60,
                    child: Transform.scale(
                      scaleX: -1,
                      child: Image.asset(
                        'assets/images/bluemascotte.png',
                        width: 280,
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 165, 10, 0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _favGames.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final game = _favGames[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => game.screen),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.rose, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.titre,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.noir,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  game.desc,
                                  style: const TextStyle(fontSize: 11, color: AppColors.noir),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
