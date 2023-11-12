import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/tavern_upgrade_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({Key? key}) : super(key: key);

  @override
  UpgradeScreenState createState() => UpgradeScreenState();
}

class UpgradeScreenState extends State<UpgradeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upgradeScreen.appBarTitle').tr(),
      ),
      body: ListView.builder(
        itemCount: tavernUpgrades.length,
        itemBuilder: (context, index) {
          var upgrade = tavernUpgrades[index];
          return ListTile(
            title: Text(upgrade.name),
            subtitle: Text(
              'upgradeScreen.itemLevelAndCost'.tr(namedArgs: {
                'level': upgrade.level.toString(),
                'cost': upgrade.goldCost.toString()
              }),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                if (player_one.gold >= upgrade.goldCost) {
                  _upgradeTavern(upgrade);
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
            icon: Icon(Icons.arrow_back),
            label: 'upgradeScreen.bottomNavBackLabel'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'upgradeScreen.bottomNavTavernLabel'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _upgradeTavern(TavernUpgrade upgrade) {
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

      // Limit the upgrade level to 100
      if (upgrade.level > 100) {
        upgrade.level = 100;
      }
    });
    _showUpgradeSuccessDialog(upgrade);
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

  void _showUpgradeSuccessDialog(TavernUpgrade upgrade) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('upgradeScreen.upgradeSuccessDialogTitle').tr(),
          content: Text('upgradeScreen.upgradeSuccessDialogContent').tr(
              namedArgs: {
                "itemName": upgrade.name,
                "itemLevel": (upgrade.level + 1).toString()
              }),
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
