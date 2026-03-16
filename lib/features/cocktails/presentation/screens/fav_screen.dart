import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';
import '../widgets/speech_bubble.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  static const _favGames = [
    {'titre': 'Pyramid', 'desc': 'Where friendships are thrown out of the window!'},
    {'titre': 'Never have I ever', 'desc': 'Reveal your secrets, or drink to get out of it'},
    {'titre': 'Flip Cup', 'desc': 'Team up and flip your way to victory!'},
    {'titre': 'Kings', 'desc': 'The ultimate card game of chaos and fun!'},
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Here is our top picks for the best drinking games to spice up your nights!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
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
                    top: 70,
                    left: 24,
                    right: 24,
                    child: SpeechBubble(
                      text: 'Our favorite games, only for you!',
                    ),
                  ),
                  Positioned(
                    bottom: -210,
                    right: -60,
                    child: Transform.scale(
                      scaleX: -1,
                      child: Image.asset(
                        'assets/images/bluemascotte.png',
                        width: 280,
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                        const Text('🍹', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 150, 10, 40),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _favGames.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final game = _favGames[i];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.rose, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game['titre']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.noir,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      game['desc']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.noir,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
