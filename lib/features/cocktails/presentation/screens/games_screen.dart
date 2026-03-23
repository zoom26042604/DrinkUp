import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive.dart';
import '../widgets/speech_bubble.dart';
import 'all_games_screen.dart';
import 'guess_demon_liquid_screen.dart';
import 'guess_my_cocktail.dart';
import 'is_it_in_my_cocktail.dart';
import 'is_your_memory_wasted.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  static const _games = [
    'Guess my demon liquid ?',
    'Guess my cocktail !',
    'Is it in my cocktail ?',
    'Is your memory wasted ?',
  ];

  void _onGameTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GuessDemonLiquidScreen(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GuessMyCocktailScreen(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IsItInMyCocktailScreen(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IsYourMemoryWastedScreen(),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coming soon !'),
            duration: Duration(seconds: 1),
          ),
        );
    }
  }

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
            SizedBox(height: rv(context, phone: 80.0, tablet: 120.0)),
            const SizedBox(height: 8),
            Text(
              'Ready to be an alcoholic ?',
              style: TextStyle(
                fontSize: rv(context, phone: 24.0, tablet: 36.0),
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 85,
                    left: 16,
                    right: 20,
                    child: SpeechBubble(
                      text: 'Here is a part of the game, go see the others !',
                    ),
                  ),
                  Positioned(
                    bottom: -200,
                    right: -160,
                    child: Image.asset(
                      'assets/images/mascotte1.png',
                      width: rv(context, phone: 450.0, tablet: 650.0),
                      height: rv(context, phone: 450.0, tablet: 650.0),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                      const Text('', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rv(context, phone: 2, tablet: 4),
                  childAspectRatio: rv(context, phone: 1.4, tablet: 1.6),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _games.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _onGameTap(context, i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.rose, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _games[i],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.noir,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllGamesScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.beige,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.rose, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'See all games',
                      style: TextStyle(
                        fontSize: 15,
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
    );
  }
}
