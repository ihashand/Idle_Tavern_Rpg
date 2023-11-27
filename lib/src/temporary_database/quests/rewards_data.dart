import 'package:game_template/src/temporary_database/quests/reward.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

List<Reward> rewards = [
  Reward("Easy Item 1", 1, Item('ulumulu', 1, ItemType.SpecialItem, 1)),
  Reward(
      "Simple Potion", 1, Item('Health Potion', 1, ItemType.HealthPotion, 1)),
  Reward("Basic Sword", 1, Item('Steel Sword', 1, ItemType.Swords, 1)),
  Reward("Common Gemstone", 1, Item('Ruby', 1, ItemType.SpecialItem, 1)),
  Reward(
      "Basic Armor Piece", 1, Item('Iron Shield', 1, ItemType.SpecialItem, 1)),
  Reward("Easy Item 2", 1, Item('xyz', 2, ItemType.SpecialItem, 1)),
  Reward("Beginner's Scroll", 1,
      Item('Scroll of Knowledge', 2, ItemType.SpecialItem, 1)),
  Reward("Novice Elixir", 1,
      Item('Elixir of Agility', 2, ItemType.SpecialItem, 1)),
  Reward("Standard Bow", 1, Item('Wooden Bow', 2, ItemType.SpecialItem, 1)),
  Reward("Uncommon Trinket", 2,
      Item('Sapphire Amulet', 2, ItemType.SpecialItem, 1)),
  Reward("Medium Item 4", 2, Item('abc', 3, ItemType.SpecialItem, 1)),
  Reward("Special Rune", 2, Item('Rune of Power', 3, ItemType.SpecialItem, 1)),
  Reward("Rare Cloak", 2,
      Item('Cloak of Invisibility', 3, ItemType.SpecialItem, 1)),
  Reward("Advanced Potion", 2,
      Item('Greater Health Potion', 3, ItemType.HealthPotion, 1)),
  Reward("Medium Item 5", 2, Item('def', 3, ItemType.SpecialItem, 1)),
  Reward("Expert's Gear Piece", 3,
      Item('Legendary Gauntlets', 3, ItemType.SpecialItem, 1)),
];
