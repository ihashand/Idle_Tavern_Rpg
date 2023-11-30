import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition_history_entry.dart';

import 'fatigue_indicator.dart';

class HeroDetailsScreen extends StatelessWidget {
  final Character character;
  const HeroDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    List<ExpeditionHistoryEntry> reversedHistory =
        character.expeditionHistory.reversed.toList();

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 196, 196, 196),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 65.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage(character.iconUrl),
                  ),
                  SizedBox(width: 20.0),
                  SizedBox(
                    width: 70,
                    child: FatigueIndicator(
                      character: character,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: character.isFatigued
                        ? () => character.unlockCharacter()
                        : null,
                    child: Text('Odblokuj'),
                  ),
                ],
              ),
            ), // Space for the status bar
            SizedBox(height: 20.0),
            Text(
              character.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),

            Text('Poziom: ${character.level}'),
            Text('kategoria: ${character.category.name}'),
            Text('Zarobek: ${character.payment}'),
            Text('Czy dostepny: ${character.isAvailableForExpedition}'),

            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: reversedHistory.length,
                itemBuilder: (context, index) {
                  ExpeditionHistoryEntry historyEntry = reversedHistory[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(historyEntry.expeditionName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DateFormat('dd/MM/yyyy')
                              .format(historyEntry.date)),
                          Text('Opis: ${historyEntry.description}'),
                          Text('Wynik: ${historyEntry.outcome}'),
                          Text('Zarobek: ${historyEntry.earnedGold} złota'),
                          Text('Czas trwania: ${historyEntry.duration} minut'),
                          _buildSpecialEventsDetails(
                              historyEntry.specialEventsDetails),
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialEventsDetails(
      List<Map<String, dynamic>> specialEventsDetails) {
    if (specialEventsDetails.isEmpty) {
      return Text('Brak zdarzeń specjalnych');
    }

    List<Widget> eventWidgets = specialEventsDetails.map((eventDetail) {
      String eventName = eventDetail["description"] ?? "Nieznane zdarzenie";
      bool? isSuccess = eventDetail["success"] as bool?;
      String eventResult = isSuccess == null
          ? "Nieznany wynik"
          : (isSuccess ? "Sukces" : "Porażka");
      return Text('$eventName: $eventResult');
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: eventWidgets,
    );
  }
}
