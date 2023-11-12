import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TavernUpgrade {
  String name;
  int level;
  int goldCost;

  TavernUpgrade(this.name, this.level, this.goldCost);
}

class UpgradeScreen extends StatefulWidget {
  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  int _selectedIndex = 0;

  List<TavernUpgrade> upgrades = [
    TavernUpgrade("Sala Główna", 1, 100),
    TavernUpgrade("Pokoje dla Ludzi", 1, 150),
    TavernUpgrade("Pokoje dla Elfów", 1, 200),
    TavernUpgrade("Pokoje dla Orków", 1, 250),
    TavernUpgrade("Pokoje dla Wampirów", 1, 300),
    TavernUpgrade("Stajnia", 1, 350),
    TavernUpgrade("Taras Karczmy", 1, 400),
    TavernUpgrade("Kuchnia", 1, 450),
    TavernUpgrade("Magazyn", 1, 500),
  ];

  int gold = 1000; // TODO Replace with actual gold value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upgradeScreen.appBarTitle').tr(),
      ),
      body: ListView.builder(
        itemCount: upgrades.length,
        itemBuilder: (context, index) {
          var upgrade = upgrades[index];
          return ListTile(
            title: Text(upgrade.name),
            subtitle: Text(
                '${'upgradeScreen.itemLevel'.tr()}: ${upgrade.level} | ${'upgradeScreen.itemCost'.tr()}: ${upgrade.goldCost} złoto'),
            trailing: ElevatedButton(
              onPressed: () {
                if (gold >= upgrade.goldCost) {
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
    setState(() {
      gold -= upgrade.goldCost;
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
          title: Text('Brak Złota').tr(),
          content: Text('Nie masz wystarczająco złota na ten zakup.').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK').tr(),
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
          title: Text('Ulepszenie Zakończone Sukcesem').tr(),
          content: Text(
                  'Gratulacje! ${upgrade.name} zostało ulepszone do poziomu ${upgrade.level}.')
              .tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK').tr(),
            ),
          ],
        );
      },
    );
  }
}
