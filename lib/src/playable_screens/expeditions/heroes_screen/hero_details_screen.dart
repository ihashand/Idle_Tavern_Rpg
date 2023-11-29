import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/fatigue_indicator.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition_history_entry.dart';

class HeroDetailsScreen extends StatelessWidget {
  final Character character;
  const HeroDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Reverse the history to show the most recent events at the top
    List<ExpeditionHistoryEntry> reversedHistory =
        character.expeditionHistory.reversed.toList();

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 196, 196, 196), // Background color
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
                  Expanded(
                    child: FatigueIndicator(character: character),
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
              style: TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold), // Hero's name
            ),
            SizedBox(height: 10.0),
            // Displaying various hero attributes
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold)), // Expedition name
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DateFormat('dd/MM/yyyy')
                              .format(historyEntry.date)), // Formatted date
                          Text(
                              'Opis: ${historyEntry.description}'), // Description
                          Text('Wynik: ${historyEntry.outcome}'), // Outcome
                          Text(
                              'Zarobek: ${historyEntry.earnedGold} złota'), // Earned gold
                          Text(
                              'Czas trwania: ${historyEntry.duration} minut'), // Duration
                          _buildSpecialEventsDetails(historyEntry
                              .specialEventsDetails), // Special events
                        ],
                      ),
                      onTap: () {
                        // Logic for tapping on an expedition history entry
                      },
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

  // Builds the details of special events
  Widget _buildSpecialEventsDetails(
      List<Map<String, dynamic>> specialEventsDetails) {
    if (specialEventsDetails.isEmpty) {
      return Text('Brak zdarzeń specjalnych'); // No special events
    }

    List<Widget> eventWidgets = specialEventsDetails.map((eventDetail) {
      String eventName =
          eventDetail["description"] ?? "Nieznane zdarzenie"; // Event name
      bool? isSuccess = eventDetail["success"] as bool?; // Success status
      String eventResult = isSuccess == null
          ? "Nieznany wynik"
          : (isSuccess ? "Sukces" : "Porażka"); // Result
      return Text('$eventName: $eventResult');
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: eventWidgets,
    );
  }
}
