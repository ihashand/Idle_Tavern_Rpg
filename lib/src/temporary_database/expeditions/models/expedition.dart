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
  DateTime? restStartTime;

  Duration get remainingRestTime {
    if (restStartTime == null) {
      return Duration.zero;
    }
    Duration timePassed = DateTime.now().difference(restStartTime!);
    Duration restDuration = Duration(minutes: duration);
    if (timePassed >= restDuration) {
      return Duration.zero;
    }
    return restDuration - timePassed;
  }

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

  void assignHero(Character character) {
    assignedHero = character;
  }

  void completeExpedition(Character character, Expedition expedition) {
    String outcome = determineOutcome(character);
    List<SpecialEventOnExpeditions> specialEvents = generateSpecialEvents();
    List<Map<String, dynamic>> specialEventsDetails = [];

    for (var event in specialEvents) {
      var result = event.executeEvent(character);
      specialEventsDetails
          .add({"description": event.description, "result": result});
    }

    int finalIncome = character.isWellPrepared(requiredLevelForExpedition)
        ? baseIncome
        : (baseIncome * 0.75).toInt();

    addIncomeToTavern(finalIncome);

    if (bonusItem != null &&
        character.isWellPrepared(requiredLevelForExpedition)) {
      addBonusItemToTavern(bonusItem);
    }

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

  String determineOutcome(Character character) {
    if (!character.isWellPrepared(requiredLevelForExpedition)) {
      return "Porażka";
    }

    bool isSuccess = Random().nextDouble() > 0.3;
    return isSuccess ? "Sukces" : "Porażka";
  }

  List<SpecialEventOnExpeditions> generateSpecialEvents() {
    List<SpecialEventOnExpeditions> events = [];

    events.add(SpecialEventOnExpeditions(
        "Dobry event",
        (Character character) => player_one.gold += 100,
        (Character character) => {}));
    events.add(SpecialEventOnExpeditions(
        "Zly event",
        (Character character) => player_one.gold += 50,
        (Character character) => player_one.gold -= 100));

    return events;
  }

  void addIncomeToTavern(int income) {
    player_one.gold += income;
  }

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
