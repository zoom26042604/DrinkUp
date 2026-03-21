import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/speech_bubble.dart';
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
            const SizedBox(height: 80),
            const SizedBox(height: 8),
            const Text(
              'Ready to be an alcoholic ?',
              style: TextStyle(
                fontSize: 24,
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
                    bottom: -170,
                    right: -160,
                    child: Image.asset(
                      'assets/images/mascotte1.png',
                      width: 450,
                      height: 450,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Text('🍹', style: TextStyle(fontSize: 40)),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
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
          ],
        ),
      ),
    );
  }
}
