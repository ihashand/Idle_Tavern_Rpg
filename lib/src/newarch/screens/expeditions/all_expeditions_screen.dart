import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_template/src/newarch/components/sort_component.dart';
import 'package:game_template/src/newarch/models/character_model.dart';
import 'package:game_template/src/newarch/models/expedition_model.dart';
import 'package:game_template/src/newarch/providers/character_provider.dart';
import 'package:game_template/src/newarch/providers/expedition_provider.dart';
import 'package:game_template/src/newarch/temporary_database/characters.dart';

// Import your data model and temporary database
int currentCarouselIndex = 0;
Character? selectedCharacter;
Character? currentAvailableCharacter;

class AllExpeditionsScreen extends ConsumerWidget {
  const AllExpeditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming 'expeditions' is your list of expeditions
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
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _buildBottomSheetContent(expedition, context, allCharacters, ref),
  ).whenComplete(() {
    _updateCurrentAvailableCharacter();
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
            child: Text(expedition.name,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          _buildCharacterCarousel(context, allCharacters),
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

Widget _buildCharacterCarousel(
    BuildContext context, List<Character> allCharacters) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 130.0,
      enlargeCenterPage: true,
      viewportFraction: 0.33,
      onPageChanged: (index, reason) =>
          _onCarouselPageChanged(index, reason, allCharacters),
    ),
    items: allCharacters
        .map((character) => _buildCarouselItem(character, context))
        .toList(),
  );
}

Widget _buildCarouselItem(Character character, BuildContext context) {
  bool isCenter = currentCarouselIndex == characters.indexOf(character);
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
              width: isCenter ? 80.0 : 60.0,
              height: isCenter ? 80.0 : 60.0,
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

void _onCarouselPageChanged(int index, CarouselPageChangedReason reason,
    List<Character> allCharacters) {
  currentCarouselIndex = index;
  if (index < allCharacters.length) {
    selectedCharacter = allCharacters[index];
  } else {
    selectedCharacter = null;
  }
}

void _updateCurrentAvailableCharacter() {
  if (characters.isNotEmpty) {
    currentAvailableCharacter = characters[0];
  }
}

void _saveExpedition(Expedition expedition, BuildContext context,
    List<Character> allCharacters, WidgetRef ref) {
  // Ustawianie ekspedycji na zajętą
  expedition.bussy =
      true; // Poprawka: Użyj operatora przypisania "=" zamiast "=="

  // Przypisanie wybranego bohatera do ekspedycji
  if (selectedCharacter != null) {
    selectedCharacter!.bussy = true; // Ustawianie bohatera na zajętego
  }

  // Aktualizacja list ekspedycji i bohaterów
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
