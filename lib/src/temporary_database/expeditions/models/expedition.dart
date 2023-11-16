import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class Expedition {
  final String name;
  final String duration;
  final String description;
  final ExpeditionCategory category;
  List<Character> assignedHeroes;

  Expedition({
    required this.name,
    required this.duration,
    required this.description,
    required this.category,
    List<Character>? assignedHeroes,
  }) : assignedHeroes = assignedHeroes ?? [];
}

enum ExpeditionCategory {
  Diplomacy,
  Exploration,
  Protection,
  Questing,
  Conquest,
  Enchantment,
  Raiding,
  Plundering,
  BeastHunting,
  ElementalTrials,
}
