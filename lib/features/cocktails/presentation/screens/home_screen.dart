import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../providers/nav_provider.dart';
import '../widgets/speech_bubble.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const SizedBox(height: 120),
            const Text(
              'Welcome to DrinkUp !',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Test your alcohol knowledge with our fun drinking games!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.noir),
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: SpeechBubble(
                      text: '4 amazing games to play with your friends!',
                    ),
                  ),
                  Positioned(
                    bottom: -290,
                    right: -120,
                    child: Image.asset(
                      'assets/images/mascotte1.png',
                      width: 380,
                      height: 380,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                      const Text('🍹', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 170, 24, 40),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.rose, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => ref.read(navIndexProvider.notifier).state = 1,
                      child: const Center(
                        child: Text(
                          'START YOUR PARTY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.noir,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Explore Favorites and Games tabs to discover all our games!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.noir,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
