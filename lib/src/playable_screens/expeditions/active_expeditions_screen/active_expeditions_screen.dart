import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';

class ActiveExpeditionsScreen extends StatelessWidget {
  final List<Expedition> expeditions;
  final Function(int) onNewExpeditionPressed;

  const ActiveExpeditionsScreen({
    super.key,
    required this.expeditions,
    required this.onNewExpeditionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color.fromARGB(255, 40, 40, 40).withOpacity(0.01),
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Aktywne ekspedycje",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: expeditions.length +
                    1, // Dodaj 1, aby uwzględnić przycisk "Nowa ekspedycja"
                itemBuilder: (context, index) {
                  if (index == expeditions.length) {
                    // Jeśli jesteśmy na ostatnim elemencie (przycisk "Nowa ekspedycja")
                    if (expeditions.length < 5) {
                      // Wyświetl przycisk tylko jeśli liczba ekspedycji jest mniejsza niż maksymalna
                      // Nowa ekspedycja
                      return ElevatedButton(
                        onPressed: () {
                          onNewExpeditionPressed(1);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          padding: EdgeInsets
                              .zero, // Usuń wewnętrzny padding, aby obrazek zajmował całą przestrzeń przycisku
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Opcjonalnie: zaokrąglenie rogów przycisku
                          ),
                          backgroundColor:
                              Colors.transparent, // Usuń domyślne tło przycisku
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Nowa ekspedycja",
                            style: TextStyle(
                              color: Colors.white, // Kolor tekstu
                              fontSize: 16.0, // Rozmiar tekstu
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Jeśli osiągnięto limit aktywnych ekspedycji, nie wyświetlaj przycisku
                      return SizedBox(); // Pusty kontener
                    }
                  } else {
                    final expedition = expeditions[index];

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: 0.7,
                                  child: Image.asset(
                                    expedition.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 16.0,
                                  right: 16.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showDetailsModal(expedition, context);
                                    },
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.0,
                                  left: 16.0,
                                  right: 16.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Obsługa przycisku "przyspiesz"
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.withOpacity(0.7),
                                          minimumSize: Size(70, 20),
                                        ),
                                        child: Text("Expedite"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Obsługa przycisku "anuluj"
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red.withOpacity(0.7),
                                          minimumSize: Size(70, 20),
                                        ),
                                        child: Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                expedition.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Opacity(
                                opacity: 1.0,
                                child: Text(
                                  //czas ekspedycji
                                  expedition.duration.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

void _showDetailsModal(Expedition expedition, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(context)
              .size
              .width, // Ustawienie szerokości na szerokość ekranu
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
              title: Text(expedition.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Category: ${expedition.category.toString().split('.').last}'),
                  Text('Skill: ${expedition.description}'),
                  Text('Payment: ${expedition.duration}'),
                  Text(
                      'Category: ${expedition.category.toString().split('.').last}'),
                  Text('Skill: ${expedition.description}'),
                  Text('Payment: ${expedition.duration}'),
                  Text(
                      'Category: ${expedition.category.toString().split('.').last}'),
                  Text('Skill: ${expedition.description}'),
                  Text('Payment: ${expedition.duration}'),
                  Text(
                      'Category: ${expedition.category.toString().split('.').last}'),
                  Text('Skill: ${expedition.description}'),
                  Text('Payment: ${expedition.duration}'),
                  Text('Skill: ${expedition.description}'),
                  Text('Payment: ${expedition.duration}'),
                  Text(
                      'Category: ${expedition.category.toString().split('.').last}'),
                  Text('Skill: ${expedition.description}'),
                  Text('Payment: ${expedition.duration}'),
                ],
              ),
              leading: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(expedition.assignedHero!
                        .iconUrl), // Use AssetImage for local assets
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    },
  );
}
