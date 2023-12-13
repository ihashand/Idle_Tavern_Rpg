import 'package:game_template/src/newarch/models/character_model.dart';

class Expedition {
  final int id;
  final String name;
  final String duration;
  final String level;
  final double progress; // Tylko dla aktywnych ekspedycji
  Character? assignedCharacter;
  bool bussy;

  Expedition(
      {required this.id,
      required this.name,
      required this.duration,
      required this.level,
      required this.progress,
      required this.bussy});
}
