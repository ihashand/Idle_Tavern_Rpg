import 'package:flutter/material.dart';
import 'package:game_template/constants/prestige.dart';
import 'package:game_template/src/settings/settings.dart';
import 'package:game_template/src/temporary_database/profile/data/race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Player Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                settingsController.playerName.value,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Gold: ${player_one.gold}",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Text(
                "Diamonds: ${player_one.diamonds}",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Races:",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      _showPossiblePrestigeLevels(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: fantasyRaces.map((race) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage(race.iconUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      "Race: ${race.race}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Prestige Level: ${race.prestigeLevel}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "Total Prestige: ${race.prestige}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: (race.prestige % 50) / 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getColorForPrestigeLevel(
                                  race.prestigeLevel,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPossiblePrestigeLevels(BuildContext context) {
    final List<String> possiblePrestigeLevels = PrestigeLvl.values
        .map((level) => level.toString().split('.').last)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Possible Prestige Levels"),
          content: Column(
            children: possiblePrestigeLevels.map((level) {
              return Text(level);
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Color _getColorForPrestigeLevel(PrestigeLvl prestigeLevel) {
    switch (prestigeLevel) {
      case PrestigeLvl.Neutral:
        return Colors.red;
      case PrestigeLvl.Cordial:
        return Colors.orange;
      case PrestigeLvl.Amicable:
        return Colors.yellow;
      case PrestigeLvl.Friendly:
        return Colors.green;
      case PrestigeLvl.Allied:
        return Colors.blue;
      case PrestigeLvl.Honored:
        return Colors.indigo;
      case PrestigeLvl.Respected:
        return Colors.purple;
      case PrestigeLvl.Revered:
        return Colors.pink;
      case PrestigeLvl.Exalted:
        return Colors.cyan;
      case PrestigeLvl.Idolized:
        return Colors.teal;
    }
  }
}
