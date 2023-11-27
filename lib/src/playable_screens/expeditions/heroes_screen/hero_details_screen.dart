import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition_history_entry.dart';
import 'package:intl/intl.dart';

class HeroDetailsScreen extends StatelessWidget {
  final Character hero;

  const HeroDetailsScreen({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    // Reverse the history to show the most recent events at the top
    List<ExpeditionHistoryEntry> reversedHistory =
        hero.expeditionHistory.reversed.toList();

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 196, 196, 196), // Background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 65.0), // Space for the status bar
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage(hero.iconUrl), // Hero's avatar
            ),
            SizedBox(height: 20.0),
            Text(
              hero.name,
              style: TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold), // Hero's name
            ),
            SizedBox(height: 10.0),
            // Displaying various hero attributes
            Text('Poziom: ${hero.level}'),
            Text('kategoria: ${hero.category}'),
            Text('dostepnosc bohatera: ${hero.isAvailable}'),
            Text('zajetosc: ${hero.isBusy}'),
            Text('platnosc: ${hero.payment}'),
            Text('Gotowosc ekspedycji: ${hero.isAvailableForExpedition}'),
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
