import 'package:game_template/constants/fantasy_race.dart';
import 'package:game_template/src/temporary_database/profile/data/prestige.dart';
import 'package:game_template/src/temporary_database/profile/models/prestige.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/rooms_upgrade_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';

class Race {
  FantasyRace race;
  late int totalPrestige;
  late Prestige prestigeLvl;
  String iconUrl;

  Race(this.race, this.iconUrl) {
    calculatePrestigeLevel();
  }

  void calculatePrestigeLevel() {
    TavernUpgrade foundRoom =
        rooms.firstWhere((room) => room.name == race.name);
    totalPrestige = foundRoom.level > 0 ? foundRoom.level * 2 : 0;

    int prestigeLevelValue =
        totalPrestige > 0 ? (totalPrestige / 50).ceil() : 1;
    prestigeLvl = prestiges.firstWhere(
        (prestige) => prestige.lvl == prestigeLevelValue,
        orElse: () => prestiges[0]);
  }
}
