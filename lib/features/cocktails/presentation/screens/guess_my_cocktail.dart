import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/nav_provider.dart';

class CocktailChallenge {
  final String nom;
  final String image;
  final List<String> ingredients;

  const CocktailChallenge({
    required this.nom,
    required this.image,
    required this.ingredients,
  });
}

class GuessMyCocktailScreen extends ConsumerStatefulWidget {
  const GuessMyCocktailScreen({super.key});

  @override
  ConsumerState<GuessMyCocktailScreen> createState() => _GuessMyCocktailScreenState();
}

class _GuessMyCocktailScreenState extends ConsumerState<GuessMyCocktailScreen> {
  final TextEditingController _controller = TextEditingController();

  static const List<CocktailChallenge> _cocktails = [
    CocktailChallenge(
      nom: 'Mojito',
      image: 'assets/images/mojito.png',
      ingredients: ['Menthe', 'Citron vert', 'Sucre de canne', 'Rhum blanc', 'Eau gazeuse'],
    ),
    CocktailChallenge(
      nom: 'Margarita',
      image: 'assets/images/margarita.png',
      ingredients: ['Tequila', 'Triple sec', 'Citron vert', 'Sel'],
    ),
    CocktailChallenge(
      nom: 'Piña Colada',
      image: 'assets/images/pina_colada.png',
      ingredients: ['Rhum blanc', 'Lait de coco', "Jus d'ananas"],
    ),
    CocktailChallenge(
      nom: 'Cosmopolitan',
      image: 'assets/images/cosmopolitan.png',
      ingredients: ['Vodka', 'Triple sec', 'Cranberry', 'Citron vert'],
    ),
    CocktailChallenge(
      nom: 'Sex on the Beach',
      image: 'assets/images/sex_on_the_beach.png',
      ingredients: ['Vodka', 'Peach Schnapps', "Jus d'orange", 'Jus de cranberry'],
    ),
  ];

  late CocktailChallenge _cocktail;
  int _revealedCount = 1;
  bool _gameOver = false;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _pickRandom();
  }

  void _pickRandom() {
    _cocktail = _cocktails[Random().nextInt(_cocktails.length)];
  }

  void _onValidate() {
    final answer = _controller.text.trim().toLowerCase();
    if (answer.isEmpty) return;

    if (answer == _cocktail.nom.toLowerCase()) {
      setState(() {
        _won = true;
        _gameOver = true;
      });
    } else if (_revealedCount < _cocktail.ingredients.length) {
      setState(() => _revealedCount++);
      _controller.clear();
    } else {
      setState(() => _gameOver = true);
    }
  }

  void _onRestart() {
    setState(() {
      _pickRandom();
      _revealedCount = 1;
      _gameOver = false;
      _won = false;
      _controller.clear();
    });
  }

  int get _score =>
      (_cocktail.ingredients.length - _revealedCount + 1).clamp(0, _cocktail.ingredients.length);

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
            padding: const EdgeInsets.only(bottom: 350),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.noir),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 170),

                const Text(
                  'Guess My Cocktail !',
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
                    'Guess the cocktail from its ingredients !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.noir),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: List.generate(_cocktail.ingredients.length, (i) {
                      final isRevealed = i < _revealedCount;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: i < _cocktail.ingredients.length - 1 ? 8 : 0,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: isRevealed
                                ? _IngredientCard(
                              key: ValueKey('revealed_$i'),
                              text: _cocktail.ingredients[i],
                            )
                                : _HiddenCard(key: ValueKey('hidden_$i')),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  '${_cocktail.ingredients.length - _revealedCount} hint(s) remaining',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.noir.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
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
                      child: Column(
                        children: [
                          Text(
                            _won ? 'Well done !' : 'It was ${_cocktail.nom} !',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.noir,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_won) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Score : $_score / ${_cocktail.ingredients.length}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.noir,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                if (!_gameOver) ...[
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
                      onSubmitted: (_) => _onValidate(),
                      decoration: InputDecoration(
                        hintText: 'Type the cocktail name...',
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
                      onTap: _onValidate,
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

                if (_gameOver) ...[
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: _onRestart,
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
                            'PLAY AGAIN',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  final String text;

  const _IngredientCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.rose, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _HiddenCard extends StatelessWidget {
  const _HiddenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.rose.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.rose, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.rose,
          ),
        ),
      ),
    );
  }
}
