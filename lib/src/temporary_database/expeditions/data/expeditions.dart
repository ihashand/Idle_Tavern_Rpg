import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';

import '../../tavern/tavern_models/item.dart';

final List<Expedition> expeditions = [
  Expedition(
    id: 1,
    name: 'Forest Exploration',
    duration: 2,
    description: 'Explore the enchanted forest',
    category: ExpeditionCategory.Exploration,
    imageUrl: 'assets/images/expeditions/exploration.jpeg',
    baseIncome: 100,
    requiredLevelForExpedition: 99,
    banDuration: Duration(minutes: 1),
    additionalItems: {
      Item("Dodatkowy przedmiot 1", 20, ItemType.SpecialItem, 1.5): 0.99,
      Item("Dodatkowy przedmiot 2", 30, ItemType.Food, 1.5): 0.50
    },
  ),
  Expedition(
    id: 2,
    name: 'Cave Exploration',
    duration: 1,
    description: 'Delve deep into the mysterious cave',
    category: ExpeditionCategory.Exploration,
    imageUrl: 'assets/images/expeditions/exploration.jpeg',
    baseIncome: 200,
    requiredLevelForExpedition: 10,
    bonusItem: Item("Sword 1", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 3", 20, ItemType.SpecialItem, 1.5): 0.99,
      Item("Dodatkowy przedmiot 4", 30, ItemType.Food, 1.5): 0.50
    },
  ),
  Expedition(
    id: 3,
    name: 'Strzelanie do mudzynow',
    duration: 5,
    description: 'Conquer the treacherous mountain peaks',
    category: ExpeditionCategory.BeastHunting,
    imageUrl: 'assets/images/expeditions/beasthunting.jpeg',
    baseIncome: 300,
    requiredLevelForExpedition: 10,
    bonusItem: Item("Sword 2", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 5", 20, ItemType.Food, 1.5): 0.99,
      Item("Dodatkowy przedmiot 6", 30, ItemType.Food, 1.5): 0.50
    },
  ),
  Expedition(
    id: 4,
    name: 'Wyprawa dyplomatyczna',
    duration: 4,
    description: 'Discover the secrets of the deep sea',
    category: ExpeditionCategory.Diplomacy,
    imageUrl: 'assets/images/expeditions/diplomacy.jpeg',
    baseIncome: 300,
    requiredLevelForExpedition: 10,
    bonusItem: Item("Sword 3", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 7", 20, ItemType.SpecialItem, 1.5): 0.99,
      Item("Dodatkowy przedmiot 8", 30, ItemType.SpecialItem, 1.5): 0.50
    },
  ),
  Expedition(
    id: 5,
    name: 'Desert Expedition',
    duration: 3,
    description: 'Survive the scorching desert sands',
    category: ExpeditionCategory.Conquest,
    imageUrl: 'assets/images/expeditions/conquest.jpeg',
    baseIncome: 100,
    requiredLevelForExpedition: 1000,
    bonusItem: Item("Sword 4", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 9", 20, ItemType.Swords, 1.5): 0.99,
      Item("Dodatkowy przedmiot 10", 30, ItemType.Swords, 1.5): 0.50
    },
  ),
  Expedition(
    id: 6,
    name: 'Polowanie na kacapa',
    duration: 2,
    description: 'Uncover the mysteries of the haunted mansion',
    category: ExpeditionCategory.BeastHunting,
    imageUrl: 'assets/images/expeditions/beasthunting.jpeg',
    baseIncome: 666,
    requiredLevelForExpedition: 10,
    bonusItem: Item("Sword 5", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 3", 20, ItemType.Swords, 1.5): 0.99,
      Item("Dodatkowy przedmiot 4", 30, ItemType.Food, 1.5): 0.50
    },
  ),
  Expedition(
    id: 7,
    name: 'Ochrona kaczora',
    duration: 1,
    description: 'Navigate through the murky swamps',
    category: ExpeditionCategory.Protection,
    imageUrl: 'assets/images/expeditions/protection.jpeg',
    baseIncome: 123,
    requiredLevelForExpedition: 10,
    bonusItem: Item("Sword 6", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 11", 20, ItemType.Swords, 1.5): 0.99,
      Item("Dodatkowy przedmiot 12", 30, ItemType.Food, 1.5): 0.50
    },
  ),
  Expedition(
    id: 8,
    name: 'Walka o osghiliat',
    duration: 1,
    description: 'Visit floating islands in the sky',
    category: ExpeditionCategory.Conquest,
    imageUrl: 'assets/images/expeditions/conquest.jpeg',
    baseIncome: 2322100,
    requiredLevelForExpedition: 10,
    bonusItem: Item("Sword 7", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 13", 20, ItemType.Food, 1.5): 0.99,
      Item("Dodatkowy przedmiot 14", 30, ItemType.Swords, 1.5): 0.50
    },
  ),
  Expedition(
    id: 9,
    name: 'Ancient Ruins Expedition',
    duration: 2,
    description: 'Search for lost treasures in ancient ruins',
    category: ExpeditionCategory.Exploration,
    imageUrl: 'assets/images/expeditions/exploration.jpeg',
    baseIncome: 111,
    requiredLevelForExpedition: 20,
    bonusItem: Item("Sword 8", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 15", 20, ItemType.Food, 1.5): 0.99,
      Item("Dodatkowy przedmiot 16", 30, ItemType.Food, 1.5): 0.50
    },
  ),
  Expedition(
    id: 666,
    name: 'Time-travel Adventure',
    duration: 1,
    description: 'Travel through time and change history',
    category: ExpeditionCategory.Diplomacy,
    imageUrl: 'assets/images/expeditions/diplomacy.jpeg',
    baseIncome: 321,
    requiredLevelForExpedition: 1,
    bonusItem: Item("Sword 9", 100, ItemType.Swords, 1.5),
    banDuration: Duration(minutes: 0),
    additionalItems: {
      Item("Dodatkowy przedmiot 17", 20, ItemType.Food, 1.5): 0.99,
      Item("Dodatkowy przedmiot 18", 30, ItemType.Food, 1.5): 0.50
    },
  ),
];
