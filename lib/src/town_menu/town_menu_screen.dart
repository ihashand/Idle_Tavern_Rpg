import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/newarch/screens/expeditions/home_expeditions_screen.dart';
import 'package:game_template/src/playable_screens/innkeeper_screen.dart';
import 'package:game_template/src/playable_screens/personnel_screen.dart';
import 'package:game_template/src/playable_screens/quests_screen.dart';
import 'package:game_template/src/playable_screens/upgrade/upgrade_screen.dart';
import 'package:game_template/src/profil/profile_screen.dart';
import '../playable_screens/expeditions/expeditions_screen.dart';
import '../playable_screens/warehouse_screen.dart';
import '../playable_screens/wood_storage_screen.dart';
import '../playable_screens/kitchen_screen.dart';

class TownMenuScreen extends StatefulWidget {
  const TownMenuScreen({Key? key}) : super(key: key);

  @override
  TownMenuScreenState createState() => TownMenuScreenState();
}

class TownMenuScreenState extends State<TownMenuScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
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
                    color: Colors.brown,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMenuItem(context, 'expeditions'.tr(), Icons.home, 0,
                    ExpeditionsScreen()),
                _buildMenuItem(context, 'upgrades'.tr(), Icons.upgrade, 1,
                    UpgradeScreen()),
                _buildMenuItem(context, 'warehouse'.tr(), Icons.storage, 2,
                    WarehouseScreen()),
                _buildMenuItem(context, 'woodstorage'.tr(), Icons.nature, 3,
                    WoodStorageScreen()),
                _buildMenuItem(context, 'kitchen'.tr(), Icons.restaurant, 4,
                    KitchenScreen()),
                _buildMenuItem(context, 'quests'.tr(), Icons.question_mark, 5,
                    QuestsScreen()),
                _buildMenuItem(context, 'innkeeper'.tr(), Icons.question_mark,
                    6, InnkeeperScreen()),
                _buildMenuItem(context, 'personnel'.tr(), Icons.question_mark,
                    7, PersonnelScreen()),
                _buildMenuItem(context, 'profile'.tr(), Icons.question_mark, 8,
                    ProfileScreen()),
                _buildMenuItem(context, 'profile'.tr(), Icons.question_mark, 9,
                    HomeExpeditionsScreen()),
              ],
            ),
          ],
        ),
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
            label: 'expeditions'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'upgrades'.tr(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpeditionsScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpgradeScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WarehouseScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WoodStorageScreen()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KitchenScreen()),
              );
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuestsScreen()),
              );
            case 6:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InnkeeperScreen()),
              );
              break;
            case 7:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PersonnelScreen()),
              );
              break;
            case 8:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            case 9:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeExpeditionsScreen()),
              );
              break;
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
