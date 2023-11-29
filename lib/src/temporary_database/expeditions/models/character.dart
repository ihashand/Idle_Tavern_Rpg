import 'package:game_template/src/temporary_database/expeditions/models/expedition_history_entry.dart';
import 'package:game_template/src/temporary_database/profile/models/race.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

import 'expedition.dart';

class Character {
  final String name;
  final CharacterCategory category;
  final int level;
  final int payment;
  final String iconUrl;
  Race race;
  late int prestigeLevel = 1;
  int expeditionsCompletedToday;
  bool isEquipped;
  bool isAvailableForExpedition = true;
  List<ExpeditionHistoryEntry> expeditionHistory = [];
  List<Item> inventory = [];

  bool isEquippedForExpedition(Expedition expedition) {
    // Logika sprawdzająca, czy bohater ma wymagane przedmioty
    // np. czy ma wystarczająco jedzenia, mikstur zdrowia, itp.
    return false;
  }

  bool isWellPrepared(int requiredLevel) {
    int preparednessCount = 0;
    if (level >= requiredLevel) preparednessCount++;
    if (expeditionsCompletedToday < 2) preparednessCount++;
    if (isEquipped) preparednessCount++;

    return preparednessCount >= 2;
  }

  double fatigueLevel = 0.0;
  double maxFatigue = 0.3;
  DateTime? restStartTime;

  Character(
      {required this.name,
      required this.category,
      required this.level,
      required this.payment,
      required this.iconUrl,
      required this.race,
      this.isEquipped = false,
      this.expeditionsCompletedToday = 0});

  void updateAfterExpedition(Expedition expedition, Character character) {
    double fatigueIncrease;

    // Ustalanie wzrostu zmęczenia na podstawie trudności ekspedycji
    switch (expedition.difficulty) {
      case ExpeditionDifficulty.easy:
        fatigueIncrease = 0.1;
        break;
      case ExpeditionDifficulty.medium:
        fatigueIncrease = 0.2;
        break;
      case ExpeditionDifficulty.hard:
        fatigueIncrease = 0.3;
        break;
      default:
        fatigueIncrease = 0.0;
    }

    fatigueLevel += fatigueIncrease;

    if (fatigueLevel >= maxFatigue) {
      restStartTime = DateTime.now(); // Ustawienie czasu rozpoczęcia odpoczynku
      character.isAvailableForExpedition = false;
    }
  }

  Duration get remainingRestTime {
    if (restStartTime == null) {
      return Duration.zero; // Brak odpoczynku, jeśli restStartTime jest null
    }
    Duration timePassed = DateTime.now().difference(restStartTime!);
    Duration restDuration = Duration(minutes: 1);
    if (timePassed >= restDuration) {
      fatigueLevel = 0.0;
      isAvailableForExpedition = true;
      return Duration.zero; // Zmęczenie zostało zresetowane
    }
    return restDuration - timePassed;
  }

  void addExpeditionHistoryEntry(ExpeditionHistoryEntry entry) {
    if (expeditionHistory.length >= 3) {
      expeditionHistory.removeAt(0); // Usuń najstarszy wpis
    }
    expeditionHistory.add(entry); // Dodaj nowy wpis
  }

  void unlockCharacter() {
    if (isFatigued) {
      fatigueLevel = 0.0;
      restStartTime = null;
      // Dodatkowe działania, takie jak aktualizacja stanu bohatera
    }
  }

  bool get isFatigued => remainingRestTime > Duration.zero;
}

// ... pozostałe metody ...
enum CharacterCategory {
  Paladin,
  Rogue,
  Diplomat,
  Warrior,
  Mage,
  Hunter,
  Priest,
  Sorcerer,
  Assassin,
  Alchemist
}
