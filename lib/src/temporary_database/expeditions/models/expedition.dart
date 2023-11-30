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
  Character? assignedHero;
  int duration;
  int baseIncome;
  Item? bonusItem;
  Duration? banDuration;
  int requiredLevelForExpedition;
  Map<Item, double> additionalItems;
  Map<ItemType, int> requiredItems;
  ExpeditionDifficulty difficulty;

  Expedition(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.imageUrl,
      required this.duration,
      required this.baseIncome,
      required this.requiredLevelForExpedition,
      required this.difficulty,
      this.requiredItems = const {},
      this.bonusItem,
      this.additionalItems = const {},
      this.banDuration});

  // Assigns a hero to the expedition
  void assignHero(Character character) {
    assignedHero = character;
  }

  // Completes the expedition and applies effects based on the outcome
  void completeExpedition(Character character, Expedition expedition) {
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

    //jezeli jestesmy przygotowani dostajemy normalne wynagrodzenie, jezeli jestesmy nieprzygotowani dostajmy 75% kwoty.
    int finalIncome = character.isWellPrepared(requiredLevelForExpedition)
        ? baseIncome
        : (baseIncome * 0.75).toInt(); // Reduced income for unprepared heroes

    //jezeli ekspedycja ma bonusowy item i dodatkowo jestesmy dobrze przygotowani, to otrzymamy dodatkowy item.
    addIncomeToTavern(finalIncome);

    if (bonusItem != null &&
        character.isWellPrepared(requiredLevelForExpedition)) {
      addBonusItemToTavern(bonusItem);
    }

    //system przeciazenia.

    // Updating the expedition history entry with more details
    character.addExpeditionHistoryEntry(ExpeditionHistoryEntry(
        name,
        DateTime.now(),
        description,
        outcome,
        finalIncome,
        duration,
        specialEventsDetails));

    character.updateAfterExpedition(expedition, character);
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
        (Character character) => player_one.gold += 100, // Success: add coins
        (Character character) => {} // Failure: no effect
        ));
    events.add(SpecialEventOnExpeditions(
            "Zly event",
            (Character character) =>
                player_one.gold += 50, // Success: add experience
            (Character character) =>
                player_one.gold -= 100) // Failure: impose a ban
        );

    return events;
  }

  // Adds income to the tavern
  void addIncomeToTavern(int income) {
    player_one.gold += income;
  }

  // Adds a bonus item to the tavern
  void addBonusItemToTavern(Item? item) {
    player_one.items.add(item!);
  }
}

enum ExpeditionCategory {
  diplomacy,
  exploration,
  protection,
  conquest,
  beastHunting,
}

enum ExpeditionDifficulty { easy, medium, hard }
