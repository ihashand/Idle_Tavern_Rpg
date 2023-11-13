import 'package:flutter/material.dart';

import 'src/temporary_database/tavern/tavern_models/item.dart';

class GameState extends ChangeNotifier {
  List<Item> inventory = [];

  void addItemToInventory(Item item) {
    inventory.add(item);
    notifyListeners();
  }
}
