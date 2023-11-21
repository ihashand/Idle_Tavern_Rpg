import 'package:game_template/constants/prestige.dart';
import 'package:game_template/constants/fantasy_race.dart';

class Race {
  FantasyRace race;
  int prestige;
  late PrestigeLvl prestigeLevel;
  String iconUrl;

  Race(this.race, this.prestige, this.iconUrl) {
    calculatePrestigeLevel();
  }

  void calculatePrestigeLevel() {
    int prestigeLevelValue = (prestige / 50).ceil();
    prestigeLevel = PrestigeLvl.values[prestigeLevelValue - 1];
  }
}
