import 'package:flutter/material.dart';
import '../constants/colors.dart';

class FavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.beigeFonce,
      child: Center(
        child: Text('Favoris', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.noir)),
      ),
    );
  }
}
