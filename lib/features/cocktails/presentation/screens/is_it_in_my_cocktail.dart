import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/nav_provider.dart';

class IsItInMyCocktailScreen extends ConsumerStatefulWidget {
  const IsItInMyCocktailScreen({super.key});

  @override
  ConsumerState<IsItInMyCocktailScreen> createState() => _IsItInMyCocktailScreenState();
}

class _IsItInMyCocktailScreenState extends ConsumerState<IsItInMyCocktailScreen> {

  final String _cocktailNom = 'Mojito';

  final List<String> _allIngredients = ['Vodka', 'Tequila', 'Grenadine'];

  final List<String> _inZone = ['Menthe', 'Rhum blanc'];

  final List<String> _notInZone = ['Lait de coco'];

  final bool _gameOver = false;
  final bool _won = false;

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

                const SizedBox(height: 90),

                const Text(
                  'Is it in my cocktail ?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.noir,
                  ),
                ),

                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Sort the ingredients of a $_cocktailNom !',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: AppColors.noir),
                  ),
                ),

                const SizedBox(height: 48),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: _allIngredients
                        .map((i) => _IngredientChip(text: i, opacity: 1.0))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _DropZone(
                          label: 'In',
                          color: AppColors.beige.withOpacity(0.35),
                          borderColor: AppColors.noir,
                          labelColor: AppColors.noir,
                          ingredients: _inZone,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: _DropZone(
                          label: 'Not in',
                          color: AppColors.beigeFonce.withOpacity(0.35),
                          borderColor: AppColors.noir,
                          labelColor: AppColors.noir,
                          ingredients: _notInZone,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_gameOver)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: _won
                            ? AppColors.rose.withOpacity(0.25)
                            : Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _won ? AppColors.rose : AppColors.noir,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _won ? 'Perfect ! You nailed it !' : 'Not quite... Try again !',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.noir,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String text;
  final double opacity;

  const _IngredientChip({required this.text, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.beige, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.noir,
          ),
        ),
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final Color labelColor;
  final List<String> ingredients;

  const _DropZone({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.labelColor,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withOpacity(0.6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 10),
          if (ingredients.isEmpty)
            Text(
              'Drop here',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.noir.withOpacity(0.3),
                fontStyle: FontStyle.italic,
              ),
            ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: ingredients
                .map((ingredient) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Text(
                ingredient,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.noir,
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
