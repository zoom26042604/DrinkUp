import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/colors.dart';
import 'core/providers/app_providers.dart';
import 'features/cocktails/presentation/providers/nav_provider.dart';
import 'features/cocktails/presentation/screens/home_screen.dart';
import 'features/cocktails/presentation/screens/fav_screen.dart';
import 'features/cocktails/presentation/screens/games_screen.dart';
import 'features/cocktails/presentation/screens/profile_screen.dart';
import 'features/cocktails/presentation/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const DrinkUpApp(),
    ),
  );
}

class DrinkUpApp extends StatelessWidget {
  const DrinkUpApp({super.key});

  static const _fallback = ['Roboto', 'sans-serif'];

  static TextTheme _applyFallback(TextTheme base) => TextTheme(
        displayLarge: base.displayLarge?.copyWith(fontFamilyFallback: _fallback),
        displayMedium: base.displayMedium?.copyWith(fontFamilyFallback: _fallback),
        displaySmall: base.displaySmall?.copyWith(fontFamilyFallback: _fallback),
        headlineLarge: base.headlineLarge?.copyWith(fontFamilyFallback: _fallback),
        headlineMedium: base.headlineMedium?.copyWith(fontFamilyFallback: _fallback),
        headlineSmall: base.headlineSmall?.copyWith(fontFamilyFallback: _fallback),
        titleLarge: base.titleLarge?.copyWith(fontFamilyFallback: _fallback),
        titleMedium: base.titleMedium?.copyWith(fontFamilyFallback: _fallback),
        titleSmall: base.titleSmall?.copyWith(fontFamilyFallback: _fallback),
        bodyLarge: base.bodyLarge?.copyWith(fontFamilyFallback: _fallback),
        bodyMedium: base.bodyMedium?.copyWith(fontFamilyFallback: _fallback),
        bodySmall: base.bodySmall?.copyWith(fontFamilyFallback: _fallback),
        labelLarge: base.labelLarge?.copyWith(fontFamilyFallback: _fallback),
        labelMedium: base.labelMedium?.copyWith(fontFamilyFallback: _fallback),
        labelSmall: base.labelSmall?.copyWith(fontFamilyFallback: _fallback),
      );

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.rose),
      fontFamily: 'CuteDino',
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'DrinkUp',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(textTheme: _applyFallback(base.textTheme)),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  static const _screens = [
    HomeScreen(),
    FavScreen(),
    GamesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    return Scaffold(
      extendBody: true,
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(navIndexProvider.notifier).state = i,
      ),
    );
  }
}