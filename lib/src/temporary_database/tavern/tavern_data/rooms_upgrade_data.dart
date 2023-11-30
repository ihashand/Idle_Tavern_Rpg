import 'package:game_template/constants/fantasy_race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';

List<TavernUpgrade> rooms = [
  TavernUpgrade(FantasyRace.human.name, 1, 150),
  TavernUpgrade(FantasyRace.dwarf.name, 0, 200),
  TavernUpgrade(FantasyRace.goblin.name, 0, 300),
  TavernUpgrade(FantasyRace.orc.name, 0, 400),
  TavernUpgrade(FantasyRace.elv.name, 0, 500),
  TavernUpgrade(FantasyRace.centaur.name, 0, 600),
  TavernUpgrade(FantasyRace.werewolf.name, 0, 700),
  TavernUpgrade(FantasyRace.vampire.name, 9, 800)
];
