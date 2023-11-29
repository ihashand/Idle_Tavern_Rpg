import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:game_template/src/settings/settings.dart';
import 'package:game_template/src/temporary_database/profile/data/prestige.dart';
import 'package:game_template/src/temporary_database/profile/data/race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('profileScreen.profile'.tr()),
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
                'profileScreen.gold'.tr(namedArgs: {
                  'gold': player_one.gold.toString(),
                }),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Text(
                'profileScreen.diamonds'.tr(namedArgs: {
                  'diamonds': player_one.diamonds.toString(),
                }),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'profileScreen.prestigeLvl'.tr(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 24.0,
                    child: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        _showPossiblePrestigeLevels(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: fantasyRaces.map((race) {
                  return Row(
                    children: [
                      Container(
                        width: 80.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(race.iconUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 16.0), // Add spacing between image and text
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          title: Text(
                            'races.${race.race.name}'.tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'profileScreen.prestige'.tr(namedArgs: {
                                  'prestigeLvl':
                                      'prestigeLvls.${race.prestigeLvl.name}'
                                          .tr()
                                }),
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                'profileScreen.totalPrestige'.tr(namedArgs: {
                                  'totalPrestige':
                                      race.totalPrestige.toString(),
                                }),
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Adjust the radius as needed
                                  child: LinearProgressIndicator(
                                    value: (race.totalPrestige % 50) / 50,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        race.prestigeLvl.color),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    ],
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('profileScreen.prestigeInfo'.tr()),
          content: Column(
            children: prestiges.map((prestige) {
              return Row(
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: prestige.color,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  Text('prestigeLvls.${prestige.name}'.tr()),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok'.tr()),
            ),
          ],
        );
      },
    );
  }
}
