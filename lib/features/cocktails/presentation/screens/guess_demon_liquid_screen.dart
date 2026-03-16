import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/speech_bubble.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/nav_provider.dart';

class GuessDemonLiquidScreen extends ConsumerStatefulWidget {
  const GuessDemonLiquidScreen({super.key});

  @override
  ConsumerState<GuessDemonLiquidScreen> createState() => _GuessDemonLiquidScreenState();
}

class _GuessDemonLiquidScreenState extends ConsumerState<GuessDemonLiquidScreen> {
  final TextEditingController _controller = TextEditingController();

  final Map<String, String> _cocktail = {
    'nom': 'Mojito',
    'image': 'assets/images/mojito.png',
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 150),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.noir),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Guess My Demon Liquid !',
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
                    'What alcohol is hiding in this cocktail ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.noir),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.rose, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            _cocktail['image']!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                color: AppColors.rose.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.local_bar,
                                size: 80,
                                color: AppColors.rose,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your answer...',
                      hintStyle: TextStyle(color: AppColors.noir.withOpacity(0.4)),
                      filled: true,
                      fillColor: AppColors.beige,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.rose, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.rose, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.noir, width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: logique de validation
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.noir, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'VALIDATE',
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
