import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class HeroDetailsScreen extends StatelessWidget {
  final Character hero;

  const HeroDetailsScreen({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły Bohatera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage(hero.iconUrl),
            ),
            SizedBox(height: 20.0),
            Text(
              hero.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
