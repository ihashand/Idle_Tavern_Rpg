import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/components/sort_component.dart';
import 'package:game_template/src/newarch/models/character_model.dart';
import 'package:game_template/src/newarch/models/expedition_model.dart';
import 'package:game_template/src/newarch/providers/character_provider.dart';
import 'package:game_template/src/newarch/providers/expedition_provider.dart';
import 'package:game_template/src/newarch/temporary_database/characters.dart';

Character? selectedCharacter;

class AllExpeditionsScreen extends ConsumerWidget {
  const AllExpeditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allExpeditions = ref
        .watch(allExpeditionsProvider)
        .where((element) => element.bussy == false)
        .toList();
    final allCharacters = ref
        .watch(characterProvider)
        .where((element) => element.bussy == false)
        .toList();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 65.0),
          SortComponent(
            sortOptions: ['Level', 'Duration'],
            onSortChanged: (sort) {
              // Implement sorting logic
            },
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
              ),
              itemCount: allExpeditions.length,
              itemBuilder: (context, index) {
                var expedition = allExpeditions[index];
                return GestureDetector(
                  onTap: () => _showExpeditionDetails(
                      expedition, context, allCharacters, ref),
                  child: Card(
                    child: ListTile(
                      title: Text(expedition.name),
                      subtitle: Text(
                          "${expedition.duration}, Level: ${expedition.level}"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showExpeditionDetails(Expedition expedition, BuildContext context,
    List<Character> allCharacters, WidgetRef ref) {
  if (allCharacters.isNotEmpty && selectedCharacter == null) {
    selectedCharacter = allCharacters.first;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _buildBottomSheetContent(expedition, context, allCharacters, ref),
  ).whenComplete(() {
    // Dodajemy to, aby zresetować wybraną postać po zamknięciu modalu
    selectedCharacter = null;
  });
}

Widget _buildBottomSheetContent(Expedition expedition, BuildContext context,
    List<Character> allCharacters, WidgetRef ref) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              expedition.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              expedition.description,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
            ),
          ),
          _buildCharacterCarousel(context, allCharacters, expedition, ref),
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  _saveExpedition(expedition, context, allCharacters, ref),
              child: Text('Save Expedition'),
            ),
          ),
        ],
      ),
    ),
  );
}

void _saveExpedition(Expedition expedition, BuildContext context,
    List<Character> allCharacters, WidgetRef ref) {
  expedition.bussy = true;

  if (selectedCharacter != null) {
    selectedCharacter!.bussy = true;
  }

  ref.read(allExpeditionsProvider.notifier).update((state) {
    return state.map((e) => e.id == expedition.id ? expedition : e).toList();
  });

  ref.read(characterProvider.notifier).update((state) {
    return state
        .map((c) => c.id == selectedCharacter!.id ? selectedCharacter! : c)
        .toList();
  });

  Navigator.of(context).pop();
}

Widget _buildCharacterCarousel(BuildContext context,
    List<Character> allCharacters, Expedition expedition, WidgetRef ref) {
  return Column(
    children: [
      Text(
        "Gotowość do wyprawy",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      Consumer(
        builder: (context, ref, child) {
          double progress = ref.watch(expeditionProgressProvider);
          return SizedBox(
            width: 200.0, // Zmniejszenie długości paska
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 15.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        },
      ),
      CarouselSlider(
        options: CarouselOptions(
          height: 130.0,
          enlargeCenterPage: true,
          viewportFraction: 0.33,
          onPageChanged: (index, reason) {
            _onCarouselPageChanged(index, reason, allCharacters, ref);
            ref.read(expeditionProgressProvider.notifier).state =
                ExpeditionProgress().calculateProgress(expedition);
          },
        ),
        items: allCharacters
            .map((character) => _buildCarouselItem(character, context))
            .toList(),
      ),
    ],
  );
}

void _onCarouselPageChanged(int index, CarouselPageChangedReason reason,
    List<Character> allCharacters, WidgetRef ref) {
  if (index < allCharacters.length) {
    selectedCharacter = allCharacters[index];
  } else {
    selectedCharacter = null;
  }
}

Widget _buildCarouselItem(Character character, BuildContext context) {
  bool isCenter = 0 == characters.indexOf(character);
  return GestureDetector(
    onTap: () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HeroDetailsScreen(character: character),
      //   ),
      // );
    },
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isCenter ? 60.0 : 40.0,
              height: isCenter ? 60.0 : 40.0,
              child: ClipOval(
                child: Image.asset(character.avatarPath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 5.0),
            Text(character.name, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

class ExpeditionProgress {
  double calculateProgress(Expedition expedition) {
    double progress = 0.0;

    // Dodaj logikę, która oblicza postęp na podstawie warunków
    if (selectedCharacter != null) {
      // Warunek 1: Bohater musi być wypoczęty
      if (selectedCharacter!.isRested) {
        progress += 20.0;
      }

      // Warunek 2: Bohater musi mieć uzupełniony prowiant i mikstury
      if (selectedCharacter!.hasSupplies) {
        progress += 30.0;
      }

      // Warunek 3: Bohater musi mieć odpowiedni poziom
      if (selectedCharacter!.level >= expedition.level) {
        progress += 50.0;
      }
    }

    // Ogranicz postęp do zakresu 0-100
    progress = progress.clamp(0.0, 100.0);

    return progress;
  }
}
