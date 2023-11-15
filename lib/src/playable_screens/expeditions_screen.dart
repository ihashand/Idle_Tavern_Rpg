import 'package:flutter/material.dart';
import 'package:game_template/GameState.dart';
import 'package:game_template/src/temporary_database/expeditions/data/heroes.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';
import 'package:provider/provider.dart';

// Główny ekran aplikacji
class ExpeditionsScreen extends StatefulWidget {
  @override
  _ExpeditionsScreenState createState() => _ExpeditionsScreenState();
}

class _ExpeditionsScreenState extends State<ExpeditionsScreen> {
  int _selectedIndex = 0;

  // Przykładowe dane

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final currentDay = gameState.currentDay;
    final List<Item> inventoryItems = gameState.inventory;
    final dailyExpeditions = gameState.dailyExpeditions;
    final dailySelectedExpeditions = gameState.dailySelectedExpeditions;

    // Wartość domyślna dla zmiennej 'content'
    Widget content = Center(child: Text('Welcome to the Main Hall!'));

    // Wybór zawartości na podstawie wybranego indeksu
    switch (_selectedIndex) {
      case 0:
        content = MainScreen(expeditions: dailySelectedExpeditions);
        break;
      case 1:
        content = ExpeditionScreen(expeditions: dailyExpeditions);
        break;
      case 2:
        content = HeroesScreen(characters: characters);
        break;
      case 3:
        content = InventoryScreen(items: inventoryItems);
        break;
    }

    // Główna struktura ekranu
    return Scaffold(
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 179, 42, 42),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Main Hall',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Expeditions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Heroes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.backpack), label: 'Inventory'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// Main hall
class MainScreen extends StatelessWidget {
  final List<Expedition> expeditions;

  MainScreen({required this.expeditions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expeditions.length,
      itemBuilder: (context, index) {
        final expedition = expeditions[index];
        String subtitleText = expedition.duration;

        if (expedition.assignedHeroes.isNotEmpty) {
          subtitleText += " - ${expedition.assignedHeroes[0].name}";
        }

        return ListTile(
          title: Text(expedition.title),
          subtitle: Text(subtitleText),
          onTap: () {
            // Navigacja do szczegółów wyprawy
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SelectedExpeditionDetailsScreen(expedition: expedition),
              ),
            );
          },
        );
      },
    );
  }
}

// Ekran wypraw
class ExpeditionScreen extends StatelessWidget {
  final List<Expedition> expeditions;

  ExpeditionScreen({required this.expeditions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expeditions.length,
      itemBuilder: (context, index) {
        final expedition = expeditions[index];
        return ListTile(
          title: Text(expedition.title),
          subtitle: Text(expedition.duration),
          onTap: () {
            // Navigacja do szczegółów wyprawy
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ExpeditionDetailsScreen(expedition: expedition)),
            );
          },
        );
      },
    );
  }
}

// Ekran szczegółów wyprawy
class ExpeditionDetailsScreen extends StatelessWidget {
  final Expedition expedition;

  ExpeditionDetailsScreen({required this.expedition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expedition.title)),
      body: Column(
        children: <Widget>[
          Text('Duration: ${expedition.duration}'),
          Text('Description: ${expedition.description}'),
          if (expedition.assignedHeroes.isNotEmpty)
            Text('Assigned hero: ${expedition.assignedHeroes.first.name}'),
          // Przycisk przypisania bohaterów do wyprawy
          ElevatedButton(
            onPressed: () => _assignHero(context, expedition),
            child: Text('Assign Heroes'),
          ),
          ElevatedButton(
            onPressed: () {
              setExpedition(expedition, context);
            },
            child: Text('Save expedition'),
          ),
        ],
      ),
    );
  }
}

// Ekran szczegółów rozpoczetych wypraw
class SelectedExpeditionDetailsScreen extends StatelessWidget {
  final Expedition expedition;

  SelectedExpeditionDetailsScreen({required this.expedition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expedition.title)),
      body: Column(
        children: <Widget>[
          Text('Duration: ${expedition.duration}'),
          Text('Description: ${expedition.description}'),
          if (expedition.assignedHeroes.isNotEmpty)
            Text('Assigned hero: ${expedition.assignedHeroes.first.name}'),
          // Przycisk przypisania bohaterów do wyprawy
        ],
      ),
    );
  }
}

void setExpedition(Expedition expedition, BuildContext context) {
  if (expedition.assignedHeroes.isEmpty) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No heroes assigned to this expedition!'),
            content: Text('Assign heroes to this expedition before saving.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return;
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hero asigned!'),
            content: Text('Congratulation, your hero is asigned'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Provider.of<GameState>(context, listen: false)
                      .setExpedition(expedition);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

// Ekran bohaterów
class HeroesScreen extends StatelessWidget {
  final List<Character> characters;

  HeroesScreen({required this.characters});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return ListTile(
          title: Text(character.name),
          subtitle: Text('${character.classType}, Level: ${character.level}'),
          onTap: () {
            // Navigacja do szczegółów bohatera
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HeroDetailsScreen(hero: character)),
            );
          },
        );
      },
    );
  }
}

// Ekran szczegółów bohatera
class HeroDetailsScreen extends StatelessWidget {
  final Character hero;

  HeroDetailsScreen({required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hero.name)),
      body: Column(
        children: <Widget>[
          Text('Level: ${hero.level}'),
          Text('Class: ${hero.classType}'),
          // Przycisk przypisania bohatera do wyprawy
          ElevatedButton(
            onPressed: () {/* Logika przypisania bohatera do wyprawy */},
            child: Text('Assign to Expedition'),
          ),
        ],
      ),
    );
  }
}

// Ekran ekwipunku
class InventoryScreen extends StatelessWidget {
  final List<Item> items;

  InventoryScreen({required this.items});

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

void _assignHero(BuildContext context, Expedition expedition) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select a Hero'),
        content: SingleChildScrollView(
          child: ListBody(
            children: characters
                .map((character) => ListTile(
                      title: Text(character.name),
                      subtitle: Text(
                          '${character.classType}, Level: ${character.level}'),
                      onTap: () => assignHeroToExpedition(
                          character, expedition, context),
                    ))
                .toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void assignHeroToExpedition(
    Character character, Expedition expedition, BuildContext context) {
  expedition.assignedHeroes.add(character);

  Provider.of<GameState>(context, listen: false)
      .dailyExpeditions
      .remove(expedition);

  Navigator.of(context).pop(); // Zamyka okno dialogowe po przypisaniu bohatera
}


//todo juz "wybrane" ekspedycje powinny sie usuwac
//todo powinny dzialac razem z systemem dnia w calej grze
//todo powinny byc generowane losowo z uwzglednieniem rodzaju wyprawy
//todo dostepni bohaterowie powinni rowniez byc generowani losowo z uwzglednieniem ich umiejetnosci
//todo szansa na wygenerowanie bohatera ze slabymi umiejetnosciami jest wysoka.

