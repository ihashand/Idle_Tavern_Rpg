import 'package:flutter/material.dart';
import 'package:game_template/GameState.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';
import 'package:provider/provider.dart';

// Definicje modeli danych
class Hero {
  final String name;
  final int level;
  final String classType;

  Hero({required this.name, required this.level, required this.classType});
}

enum ExpeditionType { regular, medium, legendary }

class Expedition {
  final String title;
  final String duration;
  final String description;
  final ExpeditionType type;
  List<Hero> assignedHeroes;

  Expedition({
    required this.title,
    required this.duration,
    required this.description,
    required this.type,
    List<Hero>? assignedHeroes,
  }) : assignedHeroes =
            assignedHeroes ?? []; // Ustawienie pustej modyfikowalnej listy
}

// Główny ekran aplikacji
class ExpeditionsScreen extends StatefulWidget {
  @override
  _ExpeditionsScreenState createState() => _ExpeditionsScreenState();
}

final List<Hero> heroes = [
  Hero(name: 'Sir Lancelot', level: 10, classType: 'Warrior'),
  Hero(name: 'Elena Moonshadow', level: 8, classType: 'Ranger'),
  Hero(name: 'Thorn Ironfist', level: 12, classType: 'Dwarf Berserker'),
  Hero(name: 'Aria Stormbringer', level: 9, classType: 'Mage'),
  Hero(name: 'Finn Shadowblade', level: 7, classType: 'Rogue'),
  Hero(name: 'Isabella Fireheart', level: 11, classType: 'Fire Elementalist'),
  Hero(name: 'Gromm Stonehammer', level: 10, classType: 'Paladin'),
  Hero(name: 'Lydia Frostwind', level: 8, classType: 'Ice Witch'),
  Hero(name: 'Darius Blackthorn', level: 9, classType: 'Assassin'),
  Hero(name: 'Aurora Starlight', level: 10, classType: 'Priest'),
];

final List<Expedition> expeditions = [
  Expedition(
      title: 'Forest Expedition',
      duration: '3 hours',
      description: 'Explore the enchanted forest',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Cave Exploration',
      duration: '4 hours',
      description: 'Delve deep into the mysterious cave',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Mountain Climb',
      duration: '5 hours',
      description: 'Conquer the treacherous mountain peaks',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Underwater Adventure',
      duration: '2 hours',
      description: 'Discover the secrets of the deep sea',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Desert Expedition',
      duration: '6 hours',
      description: 'Survive the scorching desert sands',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Haunted Mansion Quest',
      duration: '3 hours',
      description: 'Uncover the mysteries of the haunted mansion',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Swamp Exploration',
      duration: '4 hours',
      description: 'Navigate through the murky swamps',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Sky Islands Expedition',
      duration: '7 hours',
      description: 'Visit floating islands in the sky',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Ancient Ruins Expedition',
      duration: '5 hours',
      description: 'Search for lost treasures in ancient ruins',
      type: ExpeditionType.regular),
  Expedition(
      title: 'Time-travel Adventure',
      duration: '8 hours',
      description: 'Travel through time and change history',
      type: ExpeditionType.regular),
];

class _ExpeditionsScreenState extends State<ExpeditionsScreen> {
  int _selectedIndex = 0;

  // Przykładowe dane

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final currentDay = gameState.currentDay;
    final List<Item> inventoryItems = gameState.inventory;
    final expeditionsFromProvider =
        Provider.of<GameState>(context, listen: false).expeditions;

    // Wartość domyślna dla zmiennej 'content'
    Widget content = Center(child: Text('Welcome to the Main Hall!'));

    // Wybór zawartości na podstawie wybranego indeksu
    switch (_selectedIndex) {
      case 0:
        content = MainScreen(expeditions: expeditionsFromProvider);
        break;
      case 1:
        content = ExpeditionScreen(expeditions: expeditions);
        break;
      case 2:
        content = HeroesScreen(heroes: heroes);
        break;
      case 3:
        content = InventoryScreen(items: inventoryItems);
        break;
    }

    // Główna struktura ekranu
    return Scaffold(
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main Hall'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Expeditions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Heroes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.backpack), label: 'Inventory'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<Expedition> expeditions;

  MainScreen({required this.expeditions});

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

// Ekran bohaterów
class HeroesScreen extends StatelessWidget {
  final List<Hero> heroes;

  HeroesScreen({required this.heroes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        final hero = heroes[index];
        return ListTile(
          title: Text(hero.name),
          subtitle: Text('${hero.classType}, Level: ${hero.level}'),
          onTap: () {
            // Navigacja do szczegółów bohatera
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HeroDetailsScreen(hero: hero)),
            );
          },
        );
      },
    );
  }
}

// Ekran szczegółów bohatera
class HeroDetailsScreen extends StatelessWidget {
  final Hero hero;

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

void setExpedition(Expedition expedition, BuildContext context) {
  Provider.of<GameState>(context, listen: false).setExpedition(expedition);
}

void _assignHero(BuildContext context, Expedition expedition) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select a Hero'),
        content: SingleChildScrollView(
          child: ListBody(
            children: heroes
                .map((hero) => ListTile(
                      title: Text(hero.name),
                      subtitle: Text('${hero.classType}, Level: ${hero.level}'),
                      onTap: () =>
                          assignHeroToExpedition(hero, expedition, context),
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
    Hero hero, Expedition expedition, BuildContext context) {
  expedition.assignedHeroes.add(hero);

  Navigator.of(context).pop(); // Zamyka okno dialogowe po przypisaniu bohatera
}


//todo Chce zeby juz przypisana ekspedycja wyswietlala bohatera ktory zostal przypisany, w szczeolach jak i nie tyllo

//todo juz "wybrane" ekspedycje powinny sie usuwac
//todo powinny dzialac razem z systemem dnia w calej grze
//todo powinny byc generowane losowo z uwzglednieniem rodzaju wyprawy
//todo dostepni bohaterowie powinni rowniez byc generowani losowo z uwzglednieniem ich umiejetnosci
//todo szansa na wygenerowanie bohatera ze slabymi umiejetnosciami jest wysoka.

