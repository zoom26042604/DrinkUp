import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/fav_screen.dart';
import 'screens/games_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'providers/nav_provider.dart';

void main() => runApp(
  ProviderScope(child: MyApp()),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DrinkUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'CuteDino'),
      home: RootScreen(),
    );
  }
}

class RootScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Widget> screens = [
      HomeScreen(),
      FavScreen(),
      GamesScreen(),
      ProfileScreen(),
    ];

    final currentIndex = ref.watch(navIndexProvider);

    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(navIndexProvider.notifier).state = i,
      ),
    );
  }
}