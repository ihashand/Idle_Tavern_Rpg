import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class Expedition {
  int id;
  late String name;
  late String description;
  late ExpeditionCategory category;
  late String imageUrl;
  bool isHeroAssigned = false;
  Character? assignedHero;
  int duration;

  Expedition({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.duration = 0,
  });

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
