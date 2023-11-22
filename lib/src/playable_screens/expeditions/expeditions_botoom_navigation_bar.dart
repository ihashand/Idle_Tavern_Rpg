import 'package:flutter/material.dart';

class ExpeditionsBotoomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const ExpeditionsBotoomNavigationBar(
      {super.key, required this.onTabSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 43, 43, 43),
      unselectedItemColor: Colors.white,
      selectedItemColor: const Color.fromARGB(255, 179, 42, 42),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Main Hall',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Expeditions',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Heroes',
          backgroundColor: Colors.black,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTabSelected,
    );
  }
}
