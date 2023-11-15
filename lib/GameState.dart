import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

class GameState extends ChangeNotifier {
  List<Item> inventory = [];
  int _currentDay = 1;
  String _wheelOfFortuneResult = ''; // Dodane pole dla wyniku koła fortuny
  List<bool> _daysSpun = List.generate(
      7, (index) => false); // Inicjalizacja stanu odebranych nagród

  int get currentDay => _currentDay;
  String get wheelOfFortuneResult =>
      _wheelOfFortuneResult; // Getter dla wyniku koła fortuny
  List<bool> get daysSpun => _daysSpun;

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
