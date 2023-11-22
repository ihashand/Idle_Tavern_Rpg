import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/data/expeditions.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

class GameState extends ChangeNotifier {
  List<Expedition> allExpeditions = expeditions;
  List<Expedition> dailyExpeditions = [];
  List<Expedition> dailySelectedExpeditions = [];
  List<Character> allCharacters = characters;
  List<Item> inventory = [];
  int _currentDay = 1;
  String _wheelOfFortuneResult = ''; // Dodane pole dla wyniku koła fortuny
  List<bool> _daysSpun = List.generate(
      7, (index) => false); // Inicjalizacja stanu odebranych nagród

  int get currentDay => _currentDay;
  String get wheelOfFortuneResult =>
      _wheelOfFortuneResult; // Getter dla wyniku koła fortuny
  List<bool> get daysSpun => _daysSpun;

  GameState() {
    // Wywołaj funkcję generateDailyExpeditions podczas inicjalizacji GameState
    // W przeciwnym wypadku wyprawy pojawialy sie dopiero 2 dnia symulacji.
    generateDailyExpeditions();
  }

  void generateDailyExpeditions() {
    // Poniższa linia kodu generuje losowy seed na podstawie aktualnego dnia
    final randomSeed = _currentDay * 12345;
    final random = Random(randomSeed);

    dailyExpeditions.clear(); // Wyczyść poprzednie wyprawy

    // Zbiór do śledzenia użytych ID wypraw
    final Set<int> usedExpeditionIds = {};

    while (dailyExpeditions.length < 7) {
      final randomIndex = random.nextInt(expeditions.length);
      final expedition = expeditions[randomIndex];

      // Sprawdź, czy ID wyprawy zostało już użyte
      if (!usedExpeditionIds.contains(expedition.id)) {
        dailyExpeditions.add(expedition);
        usedExpeditionIds.add(expedition.id);
      }
    }

    notifyListeners();
  }

  void cancelActiveExpeditions() {
    // Sprawdź, czy są jakieś aktywne wyprawy
    if (dailySelectedExpeditions.isNotEmpty) {
      // Anuluj wszystkie aktywne wyprawy
      dailySelectedExpeditions.clear();
      notifyListeners();
    }
  }

  void addItemToInventory(Item item) {
    inventory.add(item);
    notifyListeners();
  }

  set currentDay(int day) {
    _currentDay = day;
    notifyListeners(); // Powiadamianie o zmianie wartości currentDay
  }

  void spinWheelOfFortune(String result) {
    _wheelOfFortuneResult = result;
    notifyListeners();
  }

  void resetWheelOfFortuneResult() {
    _wheelOfFortuneResult = '';
    notifyListeners();
  }

  void incrementDay() {
    if (_currentDay < 7) {
      _currentDay++;
    } else {
      _currentDay = 1; // Wraca do pierwszego dnia po osiągnięciu 7 dni
    }

    // Anuluj aktywne wyprawy przed generowaniem nowych
    cancelActiveExpeditions();

    generateDailyExpeditions();
    notifyListeners(); // Powiadamianie o zmianie wartości currentDay
  }

  set daysSpun(List<bool> value) {
    _daysSpun = value;
    notifyListeners();
  }

  // Metoda do aktualizacji stanu odebranych nagród
  void updateDaysSpun(List<bool> newDaysSpun) {
    _daysSpun = newDaysSpun;
    notifyListeners();
  }

  List<Expedition> getDailyExpeditions() {
    return dailyExpeditions;
  }

  List<Expedition> getDailySelectedExpeditions() {
    return dailySelectedExpeditions;
  }
}
