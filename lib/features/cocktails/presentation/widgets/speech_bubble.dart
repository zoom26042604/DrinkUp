import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'bubble_painter.dart';

class SpeechBubble extends StatelessWidget {
  final String text;

  const SpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12, top: 12, bottom: 12),
      child: CustomPaint(
        painter: BubblePainter(),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 22),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
