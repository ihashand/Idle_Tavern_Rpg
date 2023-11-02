import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/kitchen_screen.dart';

class KitchenIngredientsScreen extends StatefulWidget {
  final List<Ingredient> ingredients;
  final List<Recipe> recipes;

  const KitchenIngredientsScreen({
    Key? key,
    required this.ingredients,
    required this.recipes,
  }) : super(key: key);

  @override
  _KitchenIngredientsScreenState createState() =>
      _KitchenIngredientsScreenState();
}

class _KitchenIngredientsScreenState extends State<KitchenIngredientsScreen> {
  List<Ingredient> filteredIngredients = [];
  List<Recipe> filteredRecipes = [];
  bool showIngredients = true;

  @override
  void initState() {
    super.initState();
    filteredIngredients = List.from(widget.ingredients);
    filteredRecipes = List.from(widget.recipes);
  }

  void _filterIngredients(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredIngredients = List.from(widget.ingredients);
      } else {
        filteredIngredients = widget.ingredients
            .where((ingredient) => ingredient.name
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  void _filterRecipes(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredRecipes = List.from(widget.recipes);
      } else {
        filteredRecipes = widget.recipes
            .where((recipe) =>
                recipe.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipesbook'),
        automaticallyImplyLeading:
            false, //usuniecie przycisku cofania z gornego paska nawigacyjnego
      ),
      body: Column(
        children: [
          Expanded(
            child: showIngredients
                ? ListView.builder(
                    itemCount: filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = filteredIngredients[index];
                      return ListTile(
                        title: Text('${ingredient.name}'),
                      );
                    },
                  )
                : !showIngredients
                    ? ListView.builder(
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes[index];
                          return ListTile(
                            title: Text('${recipe.name}'),
                          );
                        },
                      )
                    : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back), // Przycisk cofania na dole
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(Icons.local_dining),
              onPressed: () {
                setState(() {
                  showIngredients = true;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.book),
              onPressed: () {
                setState(() {
                  showIngredients = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.bar_chart),
              onPressed: () {
                // Obsługa nawigacji do ekranu ze statystykami (dodaj odpowiednią nawigację).
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: IngredientSearchDelegate(
              showIngredients ? filteredIngredients : filteredRecipes,
              showIngredients ? _filterIngredients : _filterRecipes,
            ),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class IngredientSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> items;
  final Function(String) filterCallback;

  IngredientSearchDelegate(this.items, this.filterCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterCallback('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final searchResults = query.isEmpty
        ? items
        : items
            .where((item) => item is Ingredient
                ? item.name.toLowerCase().contains(query.toLowerCase())
                : item is Recipe
                    ? item.name.toLowerCase().contains(query.toLowerCase())
                    : false)
            .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index];
        if (item is Ingredient) {
          return ListTile(
            title: Text('${item.name}'),
          );
        } else if (item is Recipe) {
          return ListTile(
            title: Text('${item.name}'),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
