import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/kitchen_ingredients_screen.dart';

class Recipe {
  final String name;
  final List<String>
      ingredientIds; // Lista unikalnych identyfikatorów składników
  final int happinessPoints; // Punkty szczęścia
  bool isCrafted; // Flaga określająca, czy przepis został już wykorzystany

  Recipe(this.name, this.ingredientIds, this.happinessPoints)
      : isCrafted = false;
}

class Ingredient {
  final String id; // Unikalny identyfikator składnika
  final String name;
  final int cookingTime; // Czas przygotowania w sekundach lub minutach
  final int happinessPoints; // Punkty szczęścia

  Ingredient(this.id, this.name, this.cookingTime, this.happinessPoints);
}

class KitchenScreen extends StatefulWidget {
  @override
  _KitchenScreenState createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  final List<Ingredient> inventoryItems = [
    Ingredient('1', 'Chleb', 60, 5),
    Ingredient('2', 'Szynka', 120, 10),
    Ingredient('3', 'Jajko', 180, 8),
    Ingredient('4', 'Pomidor', 90, 6),
    Ingredient('5', 'Ser', 150, 7),
    Ingredient('6', 'Oliwki', 30, 3),
    Ingredient('7', 'Makaron', 120, 4),
    Ingredient('8', 'Marchewka', 60, 5),
    Ingredient('9', 'Kurczak', 240, 10),
    Ingredient('10', 'Pieczarki', 45, 4),
    Ingredient('11', 'Cebula', 45, 3),
    Ingredient('12', 'Papryka', 60, 5),
    Ingredient('13', 'Boczek', 180, 9),
    Ingredient('14', 'Ryż', 150, 6),
    Ingredient('15', 'Czosnek', 10, 2),
    Ingredient('16', 'Krewetki', 120, 8),
    Ingredient('17', 'Koper', 5, 1),
    Ingredient('18', 'Sok z cytryny', 15, 2),
    Ingredient('19', 'Pietruszka', 10, 3),
    Ingredient('20', 'Mleko', 90, 5),
    Ingredient('21', 'Chili', 5, 2),
    // Dodaj pozostałe składniki tutaj
  ];

  final List<Recipe> recipes = [
    Recipe('Kanapka z jajkiem', ['1', '3'], 15),
    Recipe('Kanapka z pomidorem i szynką', ['1', '2', '4'], 12),
    Recipe('Makaron z sosem serowym', ['7', '5'], 10),
    Recipe('Kurczak z marchewką', ['9', '8'], 15),
    Recipe('Omelet', ['3', '11', '15'], 10),
    Recipe('Spaghetti Carbonara', ['7', '13', '15'], 20),
    Recipe('Sałatka grecka', ['4', '5', '6', '18'], 18),
    Recipe('Ryż z krewetkami', ['14', '16', '18'], 14),
    Recipe('Zupa pomidorowa', ['4', '12', '15'], 10),
    Recipe('Mleko ryżowe', ['14', '20', '19'], 12),
    // Dodaj pozostałe przepisy tutaj
  ];

  List<String> craftingTable =
      []; // Lista unikalnych identyfikatorów składników na stole do kraftowania
  int maxCraftingTableSize =
      12; // Maksymalna ilość składników na stole do kraftowania

  int get craftingTableSize => craftingTable.length;

  void mixIngredients() {
    try {
      for (var recipe in recipes) {
        if (recipe.isCrafted) {
          continue; // Przepis już został wykorzystany, przejdź do kolejnego
        }

        bool canCraftRecipe = true;

        for (var ingredientId in recipe.ingredientIds) {
          if (!craftingTable.contains(ingredientId)) {
            canCraftRecipe = false;
            break;
          }
        }

        if (canCraftRecipe) {
          // Znaleziono odpowiednie składniki, tworzenie dania
          final happinessPoints = recipe.happinessPoints;
          setState(() {
            craftingTable.removeWhere((ingredientId) => recipe.ingredientIds
                .contains(ingredientId)); // Usuń użyte składniki z stołu
            recipe.isCrafted = true; // Oznacz przepis jako wykorzystany
            inventoryItems.add(Ingredient(
              DateTime.now()
                  .millisecondsSinceEpoch
                  .toString(), // Unikalny identyfikator nowego składnika
              recipe.name,
              0,
              happinessPoints,
            )); // Tworzenie nowego składnika na podstawie przepisu
          });
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Stworzyłeś nowe danie!'),
                content: Text('${recipe.name}.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
      }

      throw Exception('Nie ma takiej receptury.');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Błąd'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey,
                    height: double.infinity,
                    width: double.infinity,
                    child: DragTarget<String>(
                      onAccept: (ingredientId) {
                        // Obsługa przeciągnięcia składnika na stół
                        if (craftingTable.length < maxCraftingTableSize) {
                          setState(() {
                            craftingTable.add(ingredientId);
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Ostrzeżenie'),
                                content: Text(
                                    'Osiągnięto maksymalną ilość składników na stole do kraftowania.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: craftingTable.map((ingredientId) {
                              final ingredient = inventoryItems.firstWhere(
                                  (item) => item.id == ingredientId);
                              return Text(
                                ingredient.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0), // Dodaje odstęp 50 pikseli od góry
                        child: Column(
                          children: inventoryItems.map((ingredient) {
                            return Draggable<String>(
                              data: ingredient.id,
                              feedback: Material(
                                elevation: 4,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(ingredient.name),
                                ),
                              ),
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Text(ingredient.name),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Przycisk "Mieszaj składniki" i "Wyczyść"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: mixIngredients,
                child: Column(
                  children: const [
                    Text('Stworz'),
                  ],
                ),
              ),
              SizedBox(width: 16), // Dodaje odstęp o szerokości 16 pikseli
              ElevatedButton(
                onPressed: () {
                  // Obsługa czyszczenia stołu do craftowania
                  setState(() {
                    craftingTable.clear();
                  });
                },
                child: Column(
                  children: const [
                    Text('Wyczyść'),
                  ],
                ),
              ),
            ],
          ),
          // Dolny pasek z ikonami
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // IconButton "Cofnij" z dolnego paska
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Obsługa cofnięcia do poprzedniego menu
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: Icon(Icons.book),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KitchenIngredientsScreen(
                              ingredients: inventoryItems,
                              recipes: recipes,
                            )),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Obsługa opcji
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
