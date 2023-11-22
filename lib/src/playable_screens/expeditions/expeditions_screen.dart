// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_botoom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:game_template/game_state.dart';
import 'package:game_template/src/playable_screens/expeditions/active_expeditions_screen/active_expeditions_screen.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_screen/expedition_screen.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/heroes_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

// Main menu of expedition
class ExpeditionsScreen extends StatefulWidget {
  const ExpeditionsScreen({Key? key}) : super(key: key);

  @override
  _ExpeditionsScreenState createState() => _ExpeditionsScreenState();
}

class _ExpeditionsScreenState extends State<ExpeditionsScreen> {
  List<Expedition> dailyExpeditions = [];
  List<Expedition> dailySelectedExpeditions = [];
  List<Character> onExpeditionsCharacters = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    var gameState = Provider.of<GameState>(context, listen: false);
    _loadData(gameState);
  }

  Future<void> _loadData(GameState gameState) async {
    dailyExpeditions = gameState.getDailyExpeditions();
    dailySelectedExpeditions = gameState.getDailySelectedExpeditions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 196, 196).withOpacity(0.6),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ActiveExpeditionsScreen(
            expeditions: dailySelectedExpeditions,
            onNewExpeditionPressed: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          ExpeditionScreen(
            dailyExpeditions: dailyExpeditions,
            dailySelectedExpeditions: dailySelectedExpeditions,
            onExpeditionsCharacters: onExpeditionsCharacters,
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
