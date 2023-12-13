import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/screens/expeditions/active_expeditions_screen.dart';
import 'package:game_template/src/newarch/screens/expeditions/all_expeditions_screen.dart';
import 'package:game_template/src/newarch/screens/expeditions/characters_screen.dart';

final navigationProvider = StateProvider<int>((ref) => 0);

class HomeExpeditionsScreen extends ConsumerWidget {
  const HomeExpeditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          ActiveExpeditionsScreen(),
          AllExpeditionsScreen(),
          CharactersScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navigationProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Aktywne'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Wszystkie'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Bohaterowie'),
        ],
      ),
    );
  }
}
