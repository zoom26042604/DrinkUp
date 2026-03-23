import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive.dart';
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
            SizedBox(height: rv(context, phone: 120.0, tablet: 180.0)),
            Text(
              'Welcome to DrinkUp !',
              style: TextStyle(
                fontSize: rv(context, phone: 32.0, tablet: 48.0),
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: rv(context, phone: 24.0, tablet: 80.0)),
              child: Text(
                'Test your alcohol knowledge with our fun drinking games!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: rv(context, phone: 16.0, tablet: 22.0), color: AppColors.noir),
              ),
            ),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // SPEECH BUBBLE
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: SpeechBubble(
                      text: '4 amazing games to play with your friends!',
                    ),
                  ),

                  Positioned(
                    bottom: 90,
                    right: -80,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0),
                      child: Image.asset(
                        'assets/images/redmascotte.png',
                        width: rv(context, phone: 300.0, tablet: 460.0),
                        height: rv(context, phone: 300.0, tablet: 460.0),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                        const Text('', style: TextStyle(fontSize: 60)),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
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
                            onTap: () =>
                            ref.read(navIndexProvider.notifier).state = 1,
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
          ],
        ),
      ),
    );
  }
}
