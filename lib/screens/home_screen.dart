import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/speech_bubble.dart';

class HomeScreen extends StatelessWidget {
  final List<String> _jeux = [
    'Deviner Alcool',
    'Deviner Cocktail',
    'Ingrédients ?',
    'Memory',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.beigeFonce, AppColors.rose],
        ),
      ),
      child: SafeArea(
        child: Column(children: [

          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              'Prêt à relever le défi ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
                fontFamily: 'CuteDinos',
              ),
            ),
          ),

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                // BULLE en haut à gauche
                Positioned(
                  top: 55,
                  left: 16,
                  right: 20,
                  child: SpeechBubble(
                    text: 'Voici une partie des jeux, passe voir les autres !',
                  ),
                ),

                Positioned(
                  bottom: -150,
                  right: -160,
                  child: Container(
                    width: 450,
                    height: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/mascotte1.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Text('🍹', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          // GRILLE 2x2
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _jeux.length,
              itemBuilder: (context, i) => Container(
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.rose, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Center(
                  child: Text(
                    _jeux[i],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.noir),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}
