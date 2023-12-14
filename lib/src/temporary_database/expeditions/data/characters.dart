import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/profile/data/race.dart';

final List<Character> characters = [
  Character(
      payment: 1000,
      iconUrl: 'assets/images/characters/character_03.jpeg',
      category: CharacterCategory.warrior,
      name: 'Lancelot',
      level: 10,
      race: fantasyRaces[0]),
  Character(
      payment: 900,
      iconUrl: 'assets/images/characters/character_02.jpeg',
      category: CharacterCategory.rogue,
      name: 'Moonshadow',
      level: 8,
      race: fantasyRaces[1]),
  Character(
      payment: 1200,
      iconUrl: 'assets/images/characters/character_01.jpeg',
      category: CharacterCategory.diplomat,
      name: 'Ironfist',
      level: 12,
      race: fantasyRaces[2]),
  Character(
      payment: 1100,
      iconUrl: 'assets/images/characters/character_04.jpeg',
      category: CharacterCategory.mage,
      name: 'Stormbringer',
      level: 9,
      race: fantasyRaces[3]),
  Character(
      payment: 800,
      iconUrl: 'assets/images/characters/character_05.jpeg',
      category: CharacterCategory.rogue,
      name: 'Shadowblade',
      level: 7,
      race: fantasyRaces[4]),
  Character(
      payment: 1150,
      iconUrl: 'assets/images/characters/character_06.jpeg',
      category: CharacterCategory.sorcerer,
      name: 'Isabella',
      level: 11,
      race: fantasyRaces[3]),
  Character(
      payment: 1050,
      iconUrl: 'assets/images/characters/character_07.jpeg',
      category: CharacterCategory.paladin,
      name: 'Gromm',
      level: 10,
      race: fantasyRaces[2]),
  Character(
      payment: 950,
      iconUrl: 'assets/images/characters/character_08.jpeg',
      category: CharacterCategory.mage,
      name: 'Lydia',
      level: 8,
      race: fantasyRaces[1]),
  Character(
      payment: 960,
      iconUrl: 'assets/images/characters/character_09.jpeg',
      category: CharacterCategory.assassin,
      name: 'Darius',
      level: 9,
      race: fantasyRaces[2]),
  Character(
      payment: 1060,
      iconUrl: 'assets/images/characters/character_010.jpeg',
      category: CharacterCategory.priest,
      name: 'Aurora',
      level: 10,
      race: fantasyRaces[0]),
];
