import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/components/sort_component.dart';
import 'package:game_template/src/newarch/providers/character_provider.dart';

class CharactersScreen extends ConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Przykładowe dane
    final characters = ref.watch(characterProvider);

    return Column(
      children: [
        SizedBox(height: 65.0),
        SortComponent(
          sortOptions: ['Poziom', 'Nazwa'],
          onSortChanged: (sort) {
            // Logika sortowania listy bohaterów
          },
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              var character = characters[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 50),
                    Text(character.name),
                    Text("Poziom: ${character.level}"),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
