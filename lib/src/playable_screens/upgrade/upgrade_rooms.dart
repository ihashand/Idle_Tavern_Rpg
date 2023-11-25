import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:game_template/src/playable_screens/upgrade/rooms/vampire.dart';
import 'package:game_template/src/playable_screens/upgrade/upgrade_screen.dart';
import 'package:game_template/src/temporary_database/profile/data/race.dart';
import 'package:game_template/src/temporary_database/profile/models/race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/rooms_upgrade_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';
import 'package:game_template/src/town_menu/town_menu_screen.dart';

class UpdateRoomsScreen extends StatefulWidget {
  const UpdateRoomsScreen({Key? key}) : super(key: key);
  @override
  UpdateRoomsScreenState createState() => UpdateRoomsScreenState();
}

class UpdateRoomsScreenState extends State<UpdateRoomsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          var room = rooms[index];
          return ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VampireRoomScreen(),
                  ),
                );
              },
              child: Text('races.${room.name}'.tr()),
            ),
            subtitle: Text(
              'upgradeScreen.itemLevelAndCost'.tr(namedArgs: {
                'level': room.level.toString(),
                'cost': room.goldCost.toString()
              }),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                if (player_one.gold >= room.goldCost) {
                  _upgradeRoom(room);
                } else {
                  _showNotEnoughGoldDialog();
                }
              },
              child: Text('upgradeScreen.upgradeButton').tr(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'upgradeScreen.bottomNavMenuLabel'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'upgradeScreen.bottomNavUpgradeLabel'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TownMenuScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpgradeScreen()),
            );
          }
        },
      ),
    );
  }

  void _upgradeRoom(TavernUpgrade upgrade) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('upgradeScreen.confirmUpgradeContent').tr(namedArgs: {
            'name': upgrade.name,
            'lvl': (upgrade.level + 1).toString(),
            "cost": upgrade.goldCost.toString()
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
                if (player_one.gold >= upgrade.goldCost) {
                  _performUpgrade(upgrade);
                } else {
                  _showNotEnoughGoldDialog();
                }
              },
              child: Text('upgradeScreen.yesButton').tr(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: Text('upgradeScreen.noButton').tr(),
            ),
          ],
        );
      },
    );
  }

  void _performUpgrade(TavernUpgrade upgrade) {
    setState(() {
      player_one.gold -= upgrade.goldCost;
      upgrade.level++;
      // Apply cost multiplier for the next level
      upgrade.goldCost = (upgrade.goldCost * 1.5).round();
      Race race = fantasyRaces
          .firstWhere((fantasyRace) => fantasyRace.race.name == upgrade.name);
      race.calculatePrestigeLevel();

      // Limit the upgrade level to 100
      if (upgrade.level > 100) {
        upgrade.level = 100;
      }
    });
  }

  void _showNotEnoughGoldDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('upgradeScreen.notEnoughGoldDialogTitle').tr(),
          content: Text('upgradeScreen.notEnoughGoldDialogContent').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('upgradeScreen.okButton').tr(),
            ),
          ],
        );
      },
    );
  }
}
