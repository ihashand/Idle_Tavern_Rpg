import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/temporary_database/expeditions.dart';
import '../models/expedition_model.dart';

final activeExpeditionsProvider = StateProvider<List<Expedition>>((ref) => []);
final allExpeditionsProvider =
    StateProvider<List<Expedition>>((ref) => expeditions);
