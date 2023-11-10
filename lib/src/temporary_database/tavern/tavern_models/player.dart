import 'package:game_template/src/temporary_database/tavern/tavern_models/employee.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/main_prestige_level.dart';

class Player {
  final String id;
  int gold;
  int diamonds;
  List<Employee> employees;
  List<Item> items;
  MainPrestigeLevel mainPrestigeLevel;

  Player(this.id, this.gold, this.diamonds, this.employees, this.items,
      this.mainPrestigeLevel);
}
