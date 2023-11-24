import 'package:flutter/material.dart';
import 'package:game_template/constants/fantasy_race.dart';
import 'package:game_template/src/playable_screens/upgrade/utils.dart';

class VampireRoomScreen extends StatelessWidget {
  const VampireRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Vampire room'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 2,
            child: Image.asset(
              getRoomImagePaths(FantasyRace.Vampire),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
