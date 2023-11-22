import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/data/expeditions.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

class GameState extends ChangeNotifier {
  int timeExpedtition = 0;
  List<Item> inventory = [];
  int _currentDay = 1;
  String _wheelOfFortuneResult = ''; // Dodane pole dla wyniku koła fortuny
  List<bool> _daysSpun = List.generate(
      7, (index) => false); // Inicjalizacja stanu odebranych nagród

  int get currentDay => _currentDay;
  String get wheelOfFortuneResult =>
      _wheelOfFortuneResult; // Getter dla wyniku koła fortuny
  List<bool> get daysSpun => _daysSpun;

  List<Expedition> allExpeditions = expeditions;
  List<Expedition> dailySelectedExpeditions = [];
  List<Character> allCharacters = characters;

  List<Expedition> dailyExpeditions = [];

  GameState() {
    // Wywołaj funkcję generateDailyExpeditions podczas inicjalizacji GameState
    // W przeciwnym wypadku wyprawy pojawialy sie dopiero 2 dnia symulacji.
    generateDailyExpeditions();
  }

  void generateDailyExpeditions() {
    // Poniższa linia kodu generuje losowy seed na podstawie aktualnego dnia
    final randomSeed = _currentDay * 12345;

    // Ponieważ chcesz wygenerować 6 wypraw codziennie, możesz użyć pętli for
    dailyExpeditions.clear(); // Wyczyść poprzednie wyprawy

    for (int i = 0; i < 7; i++) {
      final randomIndex = Random(randomSeed + i).nextInt(expeditions.length);
      dailyExpeditions.add(expeditions[randomIndex]);
    }

    notifyListeners();
  }

  void setExpedition(Expedition expedition) {
    dailySelectedExpeditions.add(expedition);
    notifyListeners();
  }

  void addItemToInventory(Item item) {
    inventory.add(item);
    notifyListeners();
  }

  set currentDay(int day) {
    _currentDay = day;
    notifyListeners(); // Powiadamianie o zmianie wartości currentDay
  }

  // Setter dla wyniku koła fortuny
  set wheelOfFortuneResult(String result) {
    _wheelOfFortuneResult = result;
    notifyListeners();
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
}
