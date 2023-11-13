import 'package:game_template/src/temporary_database/quests/quest.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

final List<Quest> availableQuests = [
  Quest('10', 'Tytuł Misji 1', 'Krótki opis misji 1', 'Misje Gildijne',
      'Szczegóły misji 1', availableItemsOne,
      isInfoAvailable: true, isCompleted: false),
  Quest('20', 'Tytuł Misji 2', 'Krótki opis misji 2',
      'Misje Lokalnych Klientów', 'Szczegóły misji 2', availableItemsOne,
      isInfoAvailable: true, isCompleted: false),
  Quest('30', 'Tytuł Misji 3', 'Krótki opis misji 3', 'Misje Wydarzeniowe',
      'Szczegóły misji 3', availableItemsOne,
      isInfoAvailable: true, isCompleted: false),
  Quest('40', 'Tytuł Misji 4', 'Krótki opis misji 4',
      'Misje Dzienne i Tygodniowe', 'Szczegóły misji 4', availableItemsOne,
      isInfoAvailable: true, isCompleted: true),
  Quest('50', 'Tytuł Misji 5', 'Krótki opis misji 5', 'Misje Gildijne',
      'Szczegóły misji 5', availableItemsTwo,
      isInfoAvailable: true, isCompleted: true),
];

final List<Item> availableItemsOne = [
  Item("Ulumulu", 1),
  Item("Siekiera", 2),
  Item("Motyka", 3),
];

final List<Item> availableItemsTwo = [
  Item("Pila", 100),
  Item("Miecz", 200),
  Item("Bidon", 300),
];
