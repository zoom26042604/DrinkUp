import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/speech_bubble.dart';

class FavScreen extends StatelessWidget {
  final List<Map<String, String>> _favJeux = [
    {
      'titre': 'Shot Roulette',
      'desc': 'Le classique des soirées !',
    },
    {
      'titre': 'Je n\'ai jamais',
      'desc': 'Révèle tes secrets',
    },
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
              'Les coups de cœur de l\'équipe !',
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
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Transform.scale(
                        scaleX: -1,
                        child: Image.asset(
                          'assets/images/bluemascotte.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              Text('🍹', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
            child: Column(
              children: _favJeux.map((jeu) => Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.rose, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jeu['titre']!,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.noir,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          jeu['desc']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.noir,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),

        ]),
      ),
    );
  }
}
