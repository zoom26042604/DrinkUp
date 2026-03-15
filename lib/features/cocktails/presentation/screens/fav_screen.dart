import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';
import '../widgets/speech_bubble.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  static const _favGames = [
    {'titre': 'Shot Roulette', 'desc': 'Le classique des soirées !'},
    {'titre': 'Je n\'ai jamais', 'desc': 'Révèle tes secrets'},
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
            const SizedBox(height: 8),
            const Text(
              'Les coups de cœur de l\'équipe !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 55,
                    left: 16,
                    right: 20,
                    child: SpeechBubble(
                      text: 'Nos jeux préférés, rien que pour toi !',
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    right: -100,
                    child: Transform.scale(
                      scaleX: -1,
                      child: Image.asset(
                        'assets/images/bluemascotte.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const Text('🍹', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: Column(
                children: _favGames
                    .map(
                      (game) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.beige,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.rose, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['titre']!,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.noir,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              game['desc']!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.noir,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
