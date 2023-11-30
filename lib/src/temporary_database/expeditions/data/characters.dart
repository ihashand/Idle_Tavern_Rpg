import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/profile/data/race.dart';

final List<Character> characters = [
  Character(
      payment: 1000,
      iconUrl: 'assets/images/characters/character_03.jpeg',
      category: CharacterCategory.Warrior,
      name: 'Lancelot',
      level: 10,
      race: fantasyRaces[0]),
  Character(
      payment: 900,
      iconUrl: 'assets/images/characters/character_02.jpeg',
      category: CharacterCategory.Rogue,
      name: 'Moonshadow',
      level: 8,
      race: fantasyRaces[1]),
  Character(
      payment: 1200,
      iconUrl: 'assets/images/characters/character_01.jpeg',
      category: CharacterCategory.Diplomat,
      name: 'Ironfist',
      level: 12,
      race: fantasyRaces[2]),
  Character(
      payment: 1100,
      iconUrl: 'assets/images/characters/character_04.jpeg',
      category: CharacterCategory.Mage,
      name: 'Stormbringer',
      level: 9,
      race: fantasyRaces[3]),
  Character(
      payment: 800,
      iconUrl: 'assets/images/characters/character_05.jpeg',
      category: CharacterCategory.Rogue,
      name: 'Shadowblade',
      level: 7,
      race: fantasyRaces[4]),
  Character(
      payment: 1150,
      iconUrl: 'assets/images/characters/character_06.jpeg',
      category: CharacterCategory.Sorcerer,
      name: 'Isabella',
      level: 11,
      race: fantasyRaces[3]),
  Character(
      payment: 1050,
      iconUrl: 'assets/images/characters/character_07.jpeg',
      category: CharacterCategory.Paladin,
      name: 'Gromm',
      level: 10,
      race: fantasyRaces[2]),
  Character(
      payment: 950,
      iconUrl: 'assets/images/characters/character_08.jpeg',
      category: CharacterCategory.Mage,
      name: 'Lydia',
      level: 8,
      race: fantasyRaces[1]),
  Character(
      payment: 960,
      iconUrl: 'assets/images/characters/character_09.jpeg',
      category: CharacterCategory.Assassin,
      name: 'Darius',
      level: 9,
      race: fantasyRaces[2]),
  Character(
      payment: 1060,
      iconUrl: 'assets/images/characters/character_010.jpeg',
      category: CharacterCategory.Priest,
      name: 'Aurora',
      level: 10,
      race: fantasyRaces[0]),
];
