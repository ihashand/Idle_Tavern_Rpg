import 'package:game_template/src/temporary_database/expeditions/models/expedition_type.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';

class Expedition {
  final String title;
  final String duration;
  final String description;
  final ExpeditionType type;
  List<Character> assignedHeroes;

  Expedition({
    required this.title,
    required this.duration,
    required this.description,
    required this.type,
    List<Character>? assignedHeroes,
  }) : assignedHeroes =
            assignedHeroes ?? []; // Ustawienie pustej modyfikowalnej listy
}
