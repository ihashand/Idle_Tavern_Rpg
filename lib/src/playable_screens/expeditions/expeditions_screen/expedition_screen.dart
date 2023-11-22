import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';

class ExpeditionScreen extends StatelessWidget {
  final List<Expedition> expeditions;

  const ExpeditionScreen({super.key, required this.expeditions});

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
                      SizedBox(
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
  Timer(Duration(minutes: expedition.duration.toInt()), () {
    completeExpedition(expedition);
  });
}

void completeExpedition(Expedition expedition) {
  dailyExpeditions.add(expedition);
  dailySelectedExpeditions.remove(expedition);
  characters.add(expedition.assignedHero!);
  onExpeditionsCharacters.remove(expedition.assignedHero!);
}
