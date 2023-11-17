import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class Expedition {
  late String name;
  late String duration;
  late String description;
  late ExpeditionCategory category;
  List<Character> assignedHeroes;
  late String imageUrl;

  Expedition({
    required this.name,
    required this.duration,
    required this.description,
    required this.category,
    List<Character>? assignedHeroes,
    required this.imageUrl,
  }) : assignedHeroes = assignedHeroes ?? [];
}

enum ExpeditionCategory {
  Diplomacy,
  Exploration,
  Protection,
  Conquest,
  BeastHunting,
}
