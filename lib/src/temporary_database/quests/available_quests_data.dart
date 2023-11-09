import 'package:game_template/src/temporary_database/quests/quest.dart';

final List<Quest> availableQuests = [
  Quest('Tytuł Misji 1', 'Krótki opis misji 1', 'Misje Gildijne',
      'Szczegóły misji 1',
      isInfoAvailable: true, isCompleted: false),
  Quest('Tytuł Misji 2', 'Krótki opis misji 2', 'Misje Lokalnych Klientów',
      'Szczegóły misji 2',
      isInfoAvailable: true, isCompleted: false),
  Quest('Tytuł Misji 3', 'Krótki opis misji 3', 'Misje Wydarzeniowe',
      'Szczegóły misji 3',
      isInfoAvailable: true, isCompleted: false),
  Quest('Tytuł Misji 4', 'Krótki opis misji 4', 'Misje Dzienne i Tygodniowe',
      'Szczegóły misji 4',
      isInfoAvailable: true, isCompleted: true),
  Quest('Tytuł Misji 5', 'Krótki opis misji 5', 'Misje Gildijne',
      'Szczegóły misji 5',
      isInfoAvailable: true, isCompleted: true),
];
