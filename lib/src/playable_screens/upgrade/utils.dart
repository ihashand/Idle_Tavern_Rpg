import 'package:game_template/constants/fantasy_race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/rooms_upgrade_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';

String getRoomImagePaths(FantasyRace race) {
  TavernUpgrade foundRoom = rooms.firstWhere((room) => room.name == race.name);
  String roomLvl = '${(foundRoom.level ~/ 10) + 1}';
  String path = 'assets/images/rooms/${race.name.toLowerCase()}_$roomLvl.png';

  return path;
}
