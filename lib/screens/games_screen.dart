import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.beigeFonce,
      child: Center(
        child: Text('Jeux', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.noir)),
      ),
    );
  }
}
