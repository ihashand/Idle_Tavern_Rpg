import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_template/src/playable_screens/expeditions/heroes_screen/hero_details_screen.dart';
import 'package:game_template/src/temporary_database/expeditions/data/characters.dart';
import 'package:game_template/src/temporary_database/expeditions/models/character.dart';
import 'package:game_template/src/temporary_database/expeditions/models/expedition.dart';

class ExpeditionScreen extends StatefulWidget {
  final List<Expedition> dailyExpeditions;

  ExpeditionScreen({
    Key? key,
    required this.dailyExpeditions,
  }) : super(key: key);

  @override
  _ExpeditionScreenState createState() => _ExpeditionScreenState();
}

List<Character> onExpeditionsCharacters = [];

Character? currentAvailableCharacter;

class _ExpeditionScreenState extends State<ExpeditionScreen> {
  Expedition? selectedExpedition;
  Character? selectedCharacter;
  int currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final availableExpeditions = widget.dailyExpeditions
        .where((expedition) => !expedition.isInUse)
        .toList();
    return Material(
      color: Colors.grey.shade300,
      child: ListView.builder(
        itemCount: availableExpeditions.length,
        itemBuilder: (context, index) {
          final expedition = availableExpeditions[index];
          return _buildExpeditionCard(expedition);
        },
      ),
    );
  }

  Widget _buildExpeditionCard(Expedition expedition) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: InkWell(
        onTap: () => _onExpeditionTap(expedition),
        child: _buildExpeditionListTile(expedition),
      ),
    );
  }

  Widget _buildExpeditionListTile(Expedition expedition) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(expedition.name, style: TextStyle(fontSize: 20.0)),
          Text('${expedition.duration.toString()} min',
              style: TextStyle(fontSize: 16.0)),
        ],
      ),
      subtitle: selectedExpedition == expedition
          ? _buildExpeditionDetails(expedition)
          : Container(),
    );
  }

  Widget _buildExpeditionDetails(Expedition expedition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description: ${expedition.description}',
            style: TextStyle(fontSize: 14.0)),
        Text('Category: ${expedition.category.name}',
            style: TextStyle(fontSize: 14.0)),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () => _showExpeditionDetails(expedition),
            child: Text('Set expedition'),
          ),
        ),
      ],
    );
  }

  void _onExpeditionTap(Expedition expedition) {
    setState(() {
      selectedExpedition = selectedExpedition == expedition ? null : expedition;
      selectedCharacter = currentAvailableCharacter;
    });
  }

  void _showExpeditionDetails(Expedition expedition) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContent(expedition),
    ).whenComplete(() {
      _updateCurrentAvailableCharacter();
      setState(() {});
    });
  }

  Widget _buildBottomSheetContent(Expedition expedition) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(expedition.name,
                  style:
                      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            ),
            _buildCharacterCarousel(),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveExpedition(expedition),
                child: Text('Save Expedition'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCarousel() {
    final availableCharacters = characters
        .where((character) => character.isAvailableForExpedition)
        .toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 130.0,
        enlargeCenterPage: true,
        viewportFraction: 0.33,
        onPageChanged: _onCarouselPageChanged,
      ),
      items: availableCharacters
          .map((character) => _buildCarouselItem(character))
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    if (characters.isNotEmpty) {
      currentAvailableCharacter = characters[0];
    }
  }

  Widget _buildCarouselItem(Character character) {
    bool isCenter = currentCarouselIndex == characters.indexOf(character);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroDetailsScreen(character: character),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: isCenter ? 80.0 : 60.0,
                height: isCenter ? 80.0 : 60.0,
                child: ClipOval(
                  child: Image.asset(character.iconUrl, fit: BoxFit.cover),
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

  void _onCarouselPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      currentCarouselIndex = index;
      selectedCharacter = characters[index];
    });
  }

  void _updateCurrentAvailableCharacter() {
    if (characters.isNotEmpty) {
      currentAvailableCharacter = characters[0];
    }
  }

  void _saveExpedition(Expedition expedition) {
    if (selectedCharacter == null) {
      _showNoCharacterSelectedDialog();
    } else {
      _startExpedition(expedition);
      Navigator.of(context).pop();
    }
  }

  void _showNoCharacterSelectedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No heroes assigned to this expedition!'),
          content: Text('Assign heroes to this expedition before saving.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _startExpedition(Expedition expedition) {
    expedition.restStartTime = DateTime.now();
    expedition.assignHero(selectedCharacter!);
    expedition.isInUse = true;
    onExpeditionsCharacters.add(expedition.assignedHero!);
    characters.remove(expedition.assignedHero!);
    _startTimeExpedition(expedition);
  }

  void _startTimeExpedition(Expedition expedition) {
    Timer(
      Duration(minutes: expedition.duration.toInt()),
      () => _completeExpedition(expedition),
    );
  }

  void _completeExpedition(Expedition expedition) {
    expedition.completeExpedition(expedition.assignedHero!, expedition);
    expedition.isInUse = false;
    characters.add(expedition.assignedHero!);
    onExpeditionsCharacters.remove(expedition.assignedHero!);
  }
}
