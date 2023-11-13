import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/innkeeper_screen.dart';
import 'package:game_template/src/playable_screens/quests_screen.dart';
import 'package:game_template/src/playable_screens/upgrade_screen.dart';
import '../playable_screens/tavern_screen.dart';
import '../playable_screens/rooms_screen.dart';
import '../playable_screens/warehouse_screen.dart';
import '../playable_screens/wood_storage_screen.dart';
import '../playable_screens/kitchen_screen.dart';

class TownMenuScreen extends StatefulWidget {
  const TownMenuScreen({Key? key}) : super(key: key);

  @override
  _TownMenuScreenState createState() => _TownMenuScreenState();
}

class _TownMenuScreenState extends State<TownMenuScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: 16, right: 16),
            child: Center(
              child: Text(
                'tavern menu'.tr(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.brown, // Text color to match the medieval theme
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMenuItem(
                    context, 'tavern'.tr(), Icons.home, 0, TavernScreen()),
                _buildMenuItem(context, 'upgrades'.tr(), Icons.upgrade, 1,
                    UpgradeScreen()),
                _buildMenuItem(
                    context, 'rooms'.tr(), Icons.hotel, 2, RoomsScreen()),
                _buildMenuItem(context, 'warehouse'.tr(), Icons.storage, 3,
                    WarehouseScreen()),
                _buildMenuItem(context, 'woodstorage'.tr(), Icons.nature, 4,
                    WoodStorageScreen()),
                _buildMenuItem(context, 'kitchen'.tr(), Icons.restaurant, 5,
                    KitchenScreen()),
                _buildMenuItem(context, 'quests'.tr(), Icons.question_mark, 6,
                    QuestsScreen()),
                _buildMenuItem(context, 'innkeeper'.tr(), Icons.question_mark,
                    7, InnkeeperScreen()),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor:
                Colors.black, // Set background for bootomnavigationbar
            icon: Icon(Icons.arrow_back),
            label: 'back'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'tavern'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'upgrades'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'rooms'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'warehouse'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature),
            label: 'woodstorage'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'kitchen'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            // If "Back" is selected, use Navigator.pop to return to the previous screen.
            Navigator.pop(context);
          } else {
            // Otherwise, use Navigator.push to go to a new screen.
            // TODO zastąpić numery enumem
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TavernScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpgradeScreen()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WarehouseScreen()),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WoodStorageScreen()),
                );
                break;
              case 5:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KitchenScreen()),
                );
              case 6:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestsScreen()),
                );
              case 7:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InnkeeperScreen()),
                );
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon,
      int index, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          // Use Navigator to navigate to the selected screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        icon: Icon(
          icon,
          size: 30,
          color: Colors.brown,
        ),
        label: Text(
          title,
          style: TextStyle(
            fontFamily: 'Aceking',
            fontSize: 20,
            color: Colors.brown,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(4),
          padding: MaterialStateProperty.all(EdgeInsets.all(12)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
