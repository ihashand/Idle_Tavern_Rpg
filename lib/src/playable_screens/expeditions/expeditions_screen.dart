import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_botoom_navigation_bar.dart';
import 'package:game_template/src/playable_screens/expeditions/active_expeditions_screen/active_expeditions_screen.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_screen/expedition_screen.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/heroes_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';

import '../../temporary_database/expeditions/models/expedition.dart';

// Main menu of expedition
class ExpeditionsScreen extends StatefulWidget {
  const ExpeditionsScreen({Key? key}) : super(key: key);

  @override
  _ExpeditionsScreenState createState() => _ExpeditionsScreenState();
}

List<Expedition> dailyExpeditions = [];

class _ExpeditionsScreenState extends State<ExpeditionsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 196, 196).withOpacity(0.6),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ActiveExpeditionsScreen(
            activeExpeditions: dailyExpeditions,
            onNewExpeditionPressed: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          ExpeditionScreen(
            dailyExpeditions: dailyExpeditions,
          ),
          HeroesScreen(
            characters: characters,
            assignedHeroes: onExpeditionsCharacters,
          ),
        ],
      ),
      bottomNavigationBar: ExpeditionsBotoomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
