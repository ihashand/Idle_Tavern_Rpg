import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';
import '../heroes_screen/expedition_indicator.dart';

class ActiveExpeditionsScreen extends StatefulWidget {
  final List<Expedition> activeExpeditions;
  final Function(int) onNewExpeditionPressed;

  const ActiveExpeditionsScreen({
    super.key,
    required this.activeExpeditions,
    required this.onNewExpeditionPressed,
  });

  @override
  State<ActiveExpeditionsScreen> createState() =>
      _ActiveExpeditionsScreenState();
}

class _ActiveExpeditionsScreenState extends State<ActiveExpeditionsScreen> {
  @override
  Widget build(BuildContext context) {
    final activeExpeditions = widget.activeExpeditions
        .where((expedition) => expedition.isInUse)
        .toList();
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
                itemCount: activeExpeditions.length + 1,
                itemBuilder: (context, index) {
                  if (index == activeExpeditions.length) {
                    if (activeExpeditions.length < 5) {
                      return ElevatedButton(
                        onPressed: () {
                          widget.onNewExpeditionPressed(1);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 40),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Nowa ekspedycja",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  } else {
                    final expedition = activeExpeditions[index];
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
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.withOpacity(0.7),
                                          minimumSize: Size(70, 20),
                                        ),
                                        child: Text("Expedite"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
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
                              SizedBox(
                                  width: 200,
                                  child: ExpeditionIndicator(
                                      expedition: expedition)),
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
          width: MediaQuery.of(context).size.width,
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
                  Text('Payment: ${expedition.duration}')
                ],
              ),
              leading: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(expedition.assignedHero!.iconUrl),
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
