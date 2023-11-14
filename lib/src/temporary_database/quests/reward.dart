import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';

class Reward {
  String name;
  int value; // The lower the value, the weaker the reward
  Item item;

  Reward(this.name, this.value, this.item);
}
