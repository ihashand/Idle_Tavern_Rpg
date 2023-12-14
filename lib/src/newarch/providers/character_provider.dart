import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/models/character_model.dart';
import 'package:game_template/src/newarch/temporary_database/characters.dart';

final characterProvider = StateProvider<List<Character>>((ref) => characters);
final selectedCharacterProvider = StateProvider<Character?>((ref) => null);
