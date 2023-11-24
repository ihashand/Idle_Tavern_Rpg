import 'package:game_template/constants/prestige.dart';
import 'package:game_template/constants/fantasy_race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/rooms_upgrade_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';

class Race {
  FantasyRace race;
  late int prestige;
  late PrestigeLvl prestigeLevel;
  String iconUrl;

  Race(this.race, this.iconUrl) {
    calculatePrestigeLevel();
  }

  void calculatePrestigeLevel() {
    TavernUpgrade foundRoom =
        rooms.firstWhere((room) => room.name == race.name);
    prestige = foundRoom.level > 0 ? foundRoom.level * 2 : 0;

    int prestigeLevelValue = prestige > 0 ? (prestige / 50).ceil() : 1;
    prestigeLevel = PrestigeLvl.values[prestigeLevelValue - 1];
  }
}
