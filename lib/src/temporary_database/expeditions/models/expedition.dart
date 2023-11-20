import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class Expedition {
  late String name;
  late String description;
  late ExpeditionCategory category;
  List<Character> assignedHeroes;
  late String imageUrl;
  bool isHeroAssigned = false;
  bool isActive = false;
  Character? assignedHero;
  int remainingTime;
  int duration;

  Expedition({
    required this.name,
    required this.description,
    required this.category,
    List<Character>? assignedHeroes,
    required this.imageUrl,
    this.remainingTime = 0,
    this.duration = 0,
  }) : assignedHeroes = assignedHeroes ?? [];

  // Dodajmy metodę do przypisania bohatera
  void assignHero(Character character) {
    assignedHero = character;
    isHeroAssigned = true;
    character.isBusy = true; // Oznacz bohatera jako zajętego
  }
}

enum ExpeditionCategory {
  Diplomacy,
  Exploration,
  Protection,
  Conquest,
  BeastHunting,
}
