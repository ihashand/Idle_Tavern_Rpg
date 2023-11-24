import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/hero_details_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/filter_type.dart';

class HeroesScreen extends StatefulWidget {
  List<Character> characters;
  List<Character> assignedHeroes;

  HeroesScreen(
      {super.key, required this.characters, required this.assignedHeroes});

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
          SizedBox(height: 12.0),
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
              alignment: Alignment.center, // Wyśrodkowanie ikony
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
