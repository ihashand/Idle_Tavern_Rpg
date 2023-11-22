import 'package:flutter/material.dart';
import 'package:game_template/game_state.dart';
import 'package:game_template/src/playable_screens/expeditions/active_expeditions_screen/active_expeditions_screen.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_screen/expedition_screen.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/heroes_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';
import 'package:provider/provider.dart';

// Główny ekran aplikacji
class ExpeditionsScreen extends StatefulWidget {
  const ExpeditionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpeditionsScreenState createState() => _ExpeditionsScreenState();
}

int maxExpeditions = 5;
List<Expedition> dailySelectedExpeditions =
    []; //wybrane ekspadycje ktore mam wyswietlac
List<Expedition> dailyExpeditions =
    []; //wszystkie ekspadycje dostepne danego dnia
List<Character> onExpeditionsCharacters = [];
int _selectedIndex = 0;

class _ExpeditionsScreenState extends State<ExpeditionsScreen> {
  // Przykładowe dane

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final List<Item> inventoryItems = gameState.inventory;
    dailyExpeditions = gameState.dailyExpeditions;
    dailySelectedExpeditions = gameState.dailySelectedExpeditions;

    // Wartość domyślna dla zmiennej 'content'
    Widget content = Center(child: Text('Welcome to the Main Hall!'));

    // Wybór zawartości na podstawie wybranego indeksu
    switch (_selectedIndex) {
      case 0:
        content = ActiveExpeditionsScreen(
            expeditions: dailySelectedExpeditions,
            onNewExpeditionPressed: (index) {
              setState(() {
                _selectedIndex = index;
              });
            });
        break;
      case 1:
        content = ExpeditionScreen(expeditions: dailyExpeditions);
        break;
      case 2:
        content = HeroesScreen(
          characters: characters,
          assignedHeroes: onExpeditionsCharacters,
        );
        break;
      case 3:
        content = InventoryScreen(items: inventoryItems);
        break;
    }

    // Główna struktura ekranu
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 196, 196, 196)
          .withOpacity(0.6), // Ustawienie tła na czarne

      body: content,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(
            255, 43, 43, 43), // Kolor tła BottomNavigationBar z przejrzystością
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 179, 42, 42),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Main Hall',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Expeditions',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Heroes',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.backpack),
              label: 'Inventory',
              backgroundColor: Colors.black),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// Ekran ekwipunku
class InventoryScreen extends StatelessWidget {
  final List<Item> items;

  const InventoryScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Wyświetlanie nazwy przedmiotu
              Text(item.name),
            ],
          ),
        );
      },
    );
  }
}
