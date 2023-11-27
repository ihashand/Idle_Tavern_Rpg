import 'package:game_template/constants/fantasy_race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/tavern.dart';

List<TavernUpgrade> rooms = [
  TavernUpgrade(FantasyRace.Human.name, 1, 150),
  TavernUpgrade(FantasyRace.Dwarf.name, 0, 200),
  TavernUpgrade(FantasyRace.Goblin.name, 0, 300),
  TavernUpgrade(FantasyRace.Orc.name, 0, 400),
  TavernUpgrade(FantasyRace.Elv.name, 0, 500),
  TavernUpgrade(FantasyRace.Centaur.name, 0, 600),
  TavernUpgrade(FantasyRace.Werewolf.name, 0, 700),
  TavernUpgrade(FantasyRace.Vampire.name, 9, 800)
];
