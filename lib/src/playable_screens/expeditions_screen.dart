import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game_template/GameState.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';
import 'package:provider/provider.dart';

// Główny ekran aplikacji
class ExpeditionsScreen extends StatefulWidget {
  @override
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
        content = MainScreen(
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

class MainScreen extends StatelessWidget {
  final List<Expedition> expeditions;
  final Function(int) onNewExpeditionPressed;

  MainScreen({
    required this.expeditions,
    required this.onNewExpeditionPressed,
  });

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
                itemCount: expeditions.length +
                    1, // Dodaj 1, aby uwzględnić przycisk "Nowa ekspedycja"
                itemBuilder: (context, index) {
                  if (index == expeditions.length) {
                    // Jeśli jesteśmy na ostatnim elemencie (przycisk "Nowa ekspedycja")
                    if (expeditions.length < maxExpeditions) {
                      // Wyświetl przycisk tylko jeśli liczba ekspedycji jest mniejsza niż maksymalna
                      // Nowa ekspedycja
                      return ElevatedButton(
                        onPressed: () {
                          onNewExpeditionPressed(1);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          padding: EdgeInsets
                              .zero, // Usuń wewnętrzny padding, aby obrazek zajmował całą przestrzeń przycisku
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Opcjonalnie: zaokrąglenie rogów przycisku
                          ),
                          backgroundColor:
                              Colors.transparent, // Usuń domyślne tło przycisku
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Nowa ekspedycja",
                            style: TextStyle(
                              color: Colors.white, // Kolor tekstu
                              fontSize: 16.0, // Rozmiar tekstu
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Jeśli osiągnięto limit aktywnych ekspedycji, nie wyświetlaj przycisku
                      return SizedBox(); // Pusty kontener
                    }
                  } else {
                    final expedition = expeditions[index];
                    String subtitleText = expedition.duration.toString();

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
                                  expedition.duration.toString(),
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
                  }
                }),
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
                    Text(
                        'Category: ${expedition.category.toString().split('.').last}'),
                    Text('Skill: ${expedition.description}'),
                    Text('Payment: ${expedition.duration}'),
                    Text(
                        'Category: ${expedition.category.toString().split('.').last}'),
                    Text('Skill: ${expedition.description}'),
                    Text('Payment: ${expedition.duration}'),
                    Text(
                        'Category: ${expedition.category.toString().split('.').last}'),
                    Text('Skill: ${expedition.description}'),
                    Text('Payment: ${expedition.duration}'),
                    Text('Skill: ${expedition.description}'),
                    Text('Payment: ${expedition.duration}'),
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
// Ekran ekspedycji
class ExpeditionScreen extends StatelessWidget {
  final List<Expedition> expeditions;

  ExpeditionScreen({required this.expeditions});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Dodano widget Material
      child: ListView.builder(
        itemCount: expeditions.length,
        itemBuilder: (context, index) {
          final expedition = expeditions[index];
          return ListTile(
            title: Text(expedition.name),
            subtitle: Text(expedition.duration.toString()),
            onTap: () {
              _showExpeditionDetails(expedition, context);
            },
          );
        },
      ),
    );
  }

  void _showExpeditionDetails(Expedition expedition, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    expedition.name, // Powiększona nazwa ekspedycji
                    style: TextStyle(
                      fontSize: 24.0, // Rozmiar czcionki możesz dostosować
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category: ${expedition.category.toString().split('.').last}',
                      ),
                      Text(
                        'Skill wanted: ${expedition.description}',
                      ),
                      Text(
                        'Payment: ${expedition.duration}',
                      ),
                      Container(
                        width: 60.0,
                        height: 60.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: expedition.isHeroAssigned &&
                                  expedition.assignedHero != null
                              ? Image.asset(
                                  expedition.assignedHero!.iconUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/characters/question.jpeg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _assignHero(context, expedition),
                          child: Text('Assign Heroes'),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setExpedition(expedition, context);
                          },
                          child: Text('Save Expedition'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                        onTap: () {
                          assignHeroToExpedition(
                              character, expedition, context);
                          Navigator.of(context)
                              .pop(); // Zamyka okno dialogowe po wybraniu bohatera

                          // Otwiera ponownie szczegóły ekspedycji
                          _showExpeditionDetails(expedition, context);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void assignHeroToExpedition(
      Character character, Expedition expedition, BuildContext context) {
    expedition.assignHero(character);

    Navigator.of(context)
        .pop(); // Zamyka okno dialogowe po przypisaniu bohatera
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
  if (expedition.assignedHero == null) {
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
      },
    );
  } else if (dailySelectedExpeditions.length < maxExpeditions) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hero assigned!'),
          content: Text('Congratulations, your hero is assigned.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Usuń wyprawę z listy aktywnych ekspedycji
                dailyExpeditions.remove(expedition);
                dailySelectedExpeditions.add(expedition);
                startTimeExpedition(expedition);
                if (characters.contains(expedition.assignedHero)) {
                  onExpeditionsCharacters.add(expedition.assignedHero!);
                  characters.remove(expedition.assignedHero!);
                }

                Navigator.of(context).pop(); // Zamyka okno dialogowe
                Navigator.of(context).pop(); // Powrót do poprzedniego ekranu
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Limit reached'),
          content:
              Text('You have reached the maximum limit of active expeditions.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void startTimeExpedition(Expedition expedition) {
  // Rozpocznij odliczanie czasu wyprawy
  var test = Timer(Duration(minutes: expedition.duration.toInt()), () {
    completeExpedition(expedition);
  });
}

void completeExpedition(Expedition expedition) {
  dailyExpeditions.add(expedition);
  dailySelectedExpeditions.remove(expedition);
  characters.add(expedition.assignedHero!);
  onExpeditionsCharacters.remove(expedition.assignedHero!);
}

enum FilterType {
  All,
  OnExpedition,
  NotOnExpedition,
}

class HeroDetailsScreen extends StatelessWidget {
  final Character hero;

  HeroDetailsScreen({required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły Bohatera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage(hero.iconUrl),
            ),
            SizedBox(height: 20.0),
            Text(
              hero.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroesScreen extends StatefulWidget {
  final List<Character> characters;
  final List<Character> assignedHeroes;

  HeroesScreen({required this.characters, required this.assignedHeroes});

  @override
  _HeroesScreenState createState() => _HeroesScreenState();
}

class _HeroesScreenState extends State<HeroesScreen> {
  FilterType selectedFilter = FilterType.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 196, 196, 196),
        title: Text('Wszyscy bohaterowie'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 8.0), // Dodaj minimalny margines od prawej strony
            child: ElevatedButton(
              onPressed: () {
                _showSortOptions(context);
              },
              child: Text('Sortuj'),
            ),
          )
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 196, 196, 196),
        child: Column(
          children: [
            _buildFilteredCharacterList(),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Wszyscy'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.All;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Na wyprawie'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.OnExpedition;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('W karczmie'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.NotOnExpedition;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilteredCharacterList() {
    List<Character> filteredCharacters = [];

    if (selectedFilter == FilterType.All) {
      filteredCharacters = [...widget.characters, ...widget.assignedHeroes];
    } else if (selectedFilter == FilterType.OnExpedition) {
      filteredCharacters = [...widget.assignedHeroes];
    } else if (selectedFilter == FilterType.NotOnExpedition) {
      filteredCharacters = [...widget.characters];
    }

    // Możesz dodać sortowanie po kategoriach tutaj

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: filteredCharacters.length,
        itemBuilder: (context, index) {
          final character = filteredCharacters[index];
          return _buildCharacterCard(context, character);
        },
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, Character character) {
    bool isOnExpedition = widget.assignedHeroes.contains(character);

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroDetailsScreen(hero: character),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.centerLeft, // Wyśrodkowanie ikony
              children: [
                Positioned(
                  left: 20.0, // Przesunięcie ikony dostępności na lewo
                  top: 10.0,
                  child: Icon(
                    size: 200,
                    isOnExpedition ? Icons.close : Icons.check,
                    color: isOnExpedition ? Colors.red : Colors.green,
                  ),
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        character.iconUrl,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            character.name,
            style: TextStyle(
              fontSize: 14, // Mniejsza czcionka
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            character.category.name.toString(), // Wyświetlenie kategorii
            style: TextStyle(
              fontSize: 12, // Mniejsza czcionka dla kategorii
              color: Colors.grey,
            ),
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

void assignHeroToExpedition(
    Character character, Expedition expedition, BuildContext context) {
  expedition.assignedHeroes.add(character);

  Provider.of<GameState>(context, listen: false)
      .dailyExpeditions
      .remove(expedition);

  Navigator.of(context).pop(); // Zamyka okno dialogowe po przypisaniu bohatera
}
