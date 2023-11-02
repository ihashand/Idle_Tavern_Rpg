import 'package:flutter/material.dart';

import '../playable_screens/main_hall_screen.dart';
import '../playable_screens/rooms_screen.dart';
import '../playable_screens/warehouse_screen.dart';
import '../playable_screens/wood_storage_screen.dart';
import '../playable_screens/kitchen_screen.dart';

class TavernInteriorScreen extends StatelessWidget {
  const TavernInteriorScreen({Key? key}) : super(key: key);

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
                'Tavern Menu',
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
                    context, 'Main Hall', Icons.home, MainHallScreen()),
                _buildMenuItem(context, 'Rooms', Icons.hotel, RoomsScreen()),
                _buildMenuItem(
                    context, 'Warehouse', Icons.storage, WarehouseScreen()),
                _buildMenuItem(
                    context, 'Wood Storage', Icons.nature, WoodStorageScreen()),
                _buildMenuItem(
                    context, 'Kitchen', Icons.restaurant, KitchenScreen()),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Powrót do poprzedniego ekranu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to the respective screen
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
