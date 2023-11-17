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
      backgroundColor: const Color.fromARGB(255, 40, 40, 40)
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

class MainScreen extends StatelessWidget {
  final List<Expedition> expeditions;

  MainScreen({required this.expeditions});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color.fromARGB(255, 40, 40, 40).withOpacity(0.01),
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Aktywne ekspedycje",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expeditions.length,
              itemBuilder: (context, index) {
                final expedition = expeditions[index];
                String subtitleText = expedition.duration;

                if (expedition.assignedHeroes.isNotEmpty) {
                  subtitleText += " - ${expedition.assignedHeroes[0].name}";
                }

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.7,
                              child: Image.asset(
                                expedition.imageUrl,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            ),
                            Positioned(
                              top: 16.0,
                              right: 16.0,
                              child: GestureDetector(
                                onTap: () {
                                  _showDetailsModal(expedition, context);
                                },
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 32.0,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10.0,
                              left: 16.0,
                              right: 16.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Obsługa przycisku "przyspiesz"
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.green.withOpacity(0.7),
                                      minimumSize: Size(70, 20),
                                    ),
                                    child: Text("Expedite"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Obsługa przycisku "anuluj"
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red.withOpacity(0.7),
                                      minimumSize: Size(70, 20),
                                    ),
                                    child: Text("Cancel"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            expedition.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Opacity(
                            opacity: 1.0,
                            child: Text(
                              subtitleText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showDetailsModal(Expedition expedition, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context)
              .size
              .width, // Ustawienie szerokości na szerokość ekranu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(expedition.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Category: ${expedition.category.toString().split('.').last}'),
                    Text('Skill: ${expedition.description}'),
                    Text('Payment: ${expedition.duration}'),
                  ],
                ),
                leading: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          "assets/images/employees/ethan.jpeg"), // Use AssetImage for local assets
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
          title: Text(expedition.name),
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
      appBar: AppBar(title: Text(expedition.name)),
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
      appBar: AppBar(title: Text(expedition.name)),
      body: Column(
        children: [
          ListTile(
            title: Text(expedition.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Category: ${expedition.category.toString().split('.').last}'),
                Text('Skill: ${expedition.description}'),
                Text('Payment: ${expedition.duration}'),
              ],
            ),
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                      "expedition.iconUrl"), // Use AssetImage for local assets
                ),
              ),
            ),
          ),
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
          subtitle: Text('${character.category}, Level: ${character.level}'),
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
          Text('Class: ${hero.category}'),
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
                          '${character.category}, Level: ${character.level}'),
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
