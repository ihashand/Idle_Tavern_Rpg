import 'dart:async';

import 'package:game_template/src/temporary_database/expeditions/models/expedition_history_entry.dart';
import 'package:game_template/src/temporary_database/profile/models/race.dart';

import 'expedition.dart';

class Character {
  final String name;
  final CharacterCategory category;
  final int level;
  final int payment;
  final String iconUrl;
  final isAvailable = true;
  bool isBusy = false;
  Race race;
  late int prestigeLevel = race.prestige;
  int expeditionsCompletedToday;
  bool isEquipped;
  bool isAvailableForExpedition;
  List<ExpeditionHistoryEntry> expeditionHistory = [];

  bool isWellPrepared(int requiredLevel) {
    int preparednessCount = 0;
    if (level >= requiredLevel) preparednessCount++;
    if (expeditionsCompletedToday < 2) preparednessCount++;
    if (isEquipped) preparednessCount++;

    return preparednessCount >= 2;
  }

  double get prestigeBonus {
    // Zakładamy, że prestiż może mieć wartości od 0 do 100.
    // Przykładowa logika: 0.01 bonusu za każdy punkt prestiżu
    return prestigeLevel * 0.01;
  }

  Character(
      {required this.name,
      required this.category,
      required this.level,
      required this.payment,
      required this.iconUrl,
      required this.race,
      this.isEquipped = false,
      this.isAvailableForExpedition = false,
      this.expeditionsCompletedToday = 0});

  void addExpeditionHistoryEntry(ExpeditionHistoryEntry entry) {
    if (expeditionHistory.length >= 3) {
      expeditionHistory.removeAt(0); // Usuń najstarszy wpis
    }
    expeditionHistory.add(entry); // Dodaj nowy wpis
  }

  void afterExpedition() {
    expeditionsCompletedToday++;
    if (expeditionsCompletedToday >= 2) {
      isAvailableForExpedition = false;
      // reset `expeditionsCompletedToday` at the end of the day
    }
  }

  void applyBanAfterFailedExpedition() {
    isAvailableForExpedition = false;
    // Logika aplikowania czasowego bana w zależności od prestiżu rasy
    // Uruchom Timer do odblokowania bohatera po upłynięciu czasu bana
  }

  void applyBan(Duration banDuration) {
    isAvailableForExpedition = false;
    // Uruchom Timer do odblokowania bohatera po upłynięciu czasu bana
    Timer(banDuration, () => isAvailableForExpedition = true);
  }

  Duration calculateAdjustedBanDuration(Duration baseBanDuration) {
    // Oblicz czas trwania bana z uwzględnieniem prestiżu
    double prestigeModifier = 1 - (prestigeLevel / 100); // Przykładowa logika
    return Duration(
        seconds: (baseBanDuration.inSeconds * prestigeModifier).round());
  }
}

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
