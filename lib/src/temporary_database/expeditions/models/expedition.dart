import 'dart:math';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition_history_entry.dart';
import 'package:game_template/src/temporary_database/expeditions/models/special_event_on_expeditions.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

class Expedition {
  int id;
  String name;
  String description;
  ExpeditionCategory category;
  String imageUrl;
  bool isHeroAssigned = false;
  Character? assignedHero;
  int duration;
  int baseIncome;
  Item? bonusItem;
  Duration? banDuration;
  int requiredLevelForExpedition;
  Map<Item, double>
      additionalItems; // Items and their chances of being acquired

  Expedition(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.imageUrl,
      required this.duration,
      required this.baseIncome,
      required this.requiredLevelForExpedition,
      this.bonusItem,
      this.additionalItems = const {},
      this.banDuration});

  // Assigns a hero to the expedition
  void assignHero(Character character) {
    assignedHero = character;
    isHeroAssigned = true;
    character.isBusy = true; // Marks the hero as busy
  }

  // Completes the expedition and applies effects based on the outcome
  void completeExpedition(Character character) {
    String outcome = determineOutcome(character);
    List<SpecialEventOnExpeditions> specialEvents = generateSpecialEvents();
    List<Map<String, dynamic>> specialEventsDetails = [];

    for (var event in specialEvents) {
      var result = event.executeEvent(character);
      specialEventsDetails.add({
        "description": event.description,
        "result": result // Assuming executeEvent returns Map<String, dynamic>
      });
    }

    int finalIncome = character.isWellPrepared(requiredLevelForExpedition)
        ? baseIncome
        : (baseIncome * 0.75).toInt(); // Reduced income for unprepared heroes

    addIncomeToTavern(finalIncome);
    if (bonusItem != null &&
        character.isWellPrepared(requiredLevelForExpedition)) {
      addBonusItemToTavern(bonusItem);
    }

    if (!character.isWellPrepared(requiredLevelForExpedition) &&
        banDuration != null) {
      character.applyBan(banDuration!);
    }

    // Updating the expedition history entry with more details
    character.addExpeditionHistoryEntry(ExpeditionHistoryEntry(
        name,
        DateTime.now(),
        description,
        outcome,
        finalIncome,
        duration,
        specialEventsDetails));

    character.afterExpedition();
    updateExpeditionStatus();
  }

  // Determines the outcome of the expedition
  String determineOutcome(Character character) {
    if (!character.isWellPrepared(requiredLevelForExpedition)) {
      return "Porażka"; // Failure
    }
    // Simple random logic - example
    bool isSuccess = Random().nextDouble() > 0.3; // 70% chance of success
    return isSuccess ? "Sukces" : "Porażka"; // Success or Failure
  }

  // Generates special events, randomly deciding whether to include them
  List<SpecialEventOnExpeditions> generateSpecialEvents() {
    List<SpecialEventOnExpeditions> events = [];

    // Add random special events
    events.add(SpecialEventOnExpeditions(
        "Dobry event",
        (Character hero) => player_one.gold += 100, // Success: add coins
        (Character hero) => {} // Failure: no effect
        ));
    events.add(SpecialEventOnExpeditions(
        "Zly event",
        (Character hero) => player_one.gold += 50, // Success: add experience
        (Character hero) =>
            hero.applyBan(Duration(hours: 12)) // Failure: impose a ban
        ));

    return events;
  }

  // Random chance calculator
  bool _randomChance(double probability) {
    var rand = Random();
    return rand.nextDouble() < probability;
  }

  // Adds income to the tavern
  void addIncomeToTavern(int income) {
    player_one.gold += income;
  }

  // Adds a bonus item to the tavern
  void addBonusItemToTavern(Item? item) {
    player_one.items.add(item!);
  }

  // Updates the status of the expedition (placeholder for actual logic)
  void updateExpeditionStatus() {
    // Logic to update expedition status
  }
}

enum ExpeditionCategory {
  Diplomacy,
  Exploration,
  Protection,
  Conquest,
  BeastHunting,
}
