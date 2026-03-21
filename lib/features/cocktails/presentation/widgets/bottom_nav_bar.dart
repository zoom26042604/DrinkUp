import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem('assets/images/maison.png', 0),
          _navItem('assets/images/manette.png', 1),
          GestureDetector(
            onTap: () => onTap(0),
            child: Image.asset(
              'assets/images/favicon.png',
              height: 80,
              errorBuilder: (_, _, _) => const Icon(
                Icons.local_bar_rounded,
                size: 40,
                color: AppColors.noir,
              ),
            ),
          ),
          _navItem('assets/images/etoiles.png', 2),
          _navItem('assets/images/user.png', 3),
        ],
      ),
    );
  }

  Widget _navItem(String asset, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.beigeFonce.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          asset,
          height: 40,
          errorBuilder: (_, _, _) => Icon(
            Icons.circle,
            color: isActive ? AppColors.rose : Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }
}
