import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

const _gages = [
  'Dare: Take a sip!',
  'Dare: Do a shot!',
  'Dare: Tell the group a joke!',
  'Dare: Sing for 10 seconds!',
  'Dare: Impersonate someone here!',
  'Dare: Call someone at random!',
  'Dare: Give a compliment to the person on your left!',
  'Dare: Do 10 push-ups!',
];

String gameGage(String seed) => _gages[seed.hashCode.abs() % _gages.length];

Widget buildStarScore(int score, int max, {Color color = AppColors.white}) {
  final stars = max == 0 ? 0 : ((score / max) * 5).round().clamp(1, 5);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (i) => Icon(
        i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
        color: color,
        size: 28,
      ),
    ),
  );
}

Widget buildMoveStars(int moves, int totalPairs) {
  final int stars;
  if (moves <= totalPairs) {
    stars = 3;
  } else if (moves <= totalPairs * 2) {
    stars = 2;
  } else {
    stars = 1;
  }
  return Column(
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Icon(
            i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        stars == 3 ? 'Perfect!' : stars == 2 ? 'Well done!' : 'Not bad!',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class GameResultCard extends StatelessWidget {
  final bool won;
  final String title;
  final String? detail;
  final Widget? scoreWidget;
  final VoidCallback onPlayAgain;

  const GameResultCard({
    super.key,
    required this.won,
    required this.title,
    this.detail,
    this.scoreWidget,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final bg = won ? AppColors.rose : AppColors.beige;
    final fg = won ? AppColors.white : AppColors.noir;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: fg, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: fg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                won ? Icons.star_rounded : Icons.sentiment_dissatisfied_rounded,
                color: fg,
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                style: TextStyle(
                  fontSize: 13,
                  color: fg.withValues(alpha: 0.85),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (scoreWidget != null) ...[
              const SizedBox(height: 12),
              scoreWidget!,
            ],
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onPlayAgain,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                decoration: BoxDecoration(
                  color: won ? AppColors.white.withValues(alpha: 0.22) : AppColors.rose,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: fg, width: 1.5),
                ),
                child: const Text(
                  'PLAY AGAIN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
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
