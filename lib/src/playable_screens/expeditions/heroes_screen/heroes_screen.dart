import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/hero_details_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/filter_type.dart';
import 'fatigue_indicator.dart';

class HeroesScreen extends StatefulWidget {
  List<Character> characters;
  List<Character> assignedHeroes;

  HeroesScreen(
      {super.key, required this.characters, required this.assignedHeroes});

  @override
  _HeroesScreenState createState() => _HeroesScreenState();
}

class _HeroesScreenState extends State<HeroesScreen> {
  FilterType selectedFilter = FilterType.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 196, 196, 196),
        title: Text('All Heroes'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _showSortOptions(context);
              },
              child: Text('Sort'),
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
              title: Text('All'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.all;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('On Expedition'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.onExpedition;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('At Tavern'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.notOnExpedition;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('After Fatigue'),
              onTap: () {
                setState(() {
                  selectedFilter = FilterType.byFatigue;
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

    if (selectedFilter == FilterType.all) {
      filteredCharacters = [...widget.characters, ...widget.assignedHeroes];
    } else if (selectedFilter == FilterType.onExpedition) {
      filteredCharacters = [...widget.assignedHeroes];
    } else if (selectedFilter == FilterType.notOnExpedition) {
      filteredCharacters = [...widget.characters];
    } else if (selectedFilter == FilterType.byFatigue) {
      filteredCharacters = widget.characters
          .where((character) => character.fatigueLevel >= character.maxFatigue)
          .toList();
    }

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
    bool isFatigued = character.fatigueLevel >= character.maxFatigue;
    Color borderColor = Colors.transparent;

    if (isFatigued) {
      borderColor = Colors.red;
    } else if (isOnExpedition) {
      borderColor = Colors.yellow;
    } else {
      borderColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroDetailsScreen(character: character),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
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
                Positioned(
                  right: 10.0,
                  top: 4.0,
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        character.level.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              character.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (isFatigued)
            SizedBox(
              width: 80.0,
              child: FatigueIndicator(
                character: character,
              ),
            )
        ],
      ),
    );
  }
}
