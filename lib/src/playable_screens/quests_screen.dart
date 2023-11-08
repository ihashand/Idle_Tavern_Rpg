import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class QuestsScreen extends StatefulWidget {
  @override
  _QuestsScreenState createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  String selectedCategory = 'Wszystkie';

  final List<String> categories = [
    'Wszystkie',
    'Misje Gildijne',
    'Misje Lokalnych Klientów',
    'Misje Wydarzeniowe',
    'Misje Dzienne i Tygodniowe'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('quests').tr(),
        actions: [
          PopupMenuButton<String>(
            onSelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
            itemBuilder: (BuildContext context) {
              return categories.map((String category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Text(category).tr(),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (var quest in availableQuests)
            if (selectedCategory == 'Wszystkie' ||
                quest.category == selectedCategory)
              ListTile(
                title: Text(quest.title).tr(),
                subtitle: Text(quest.description).tr(),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (quest.isInfoAvailable)
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          _showInfoDialog(context, quest);
                        },
                      ),
                    if (quest.isCompleted)
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          _showRewardDialog(context);
                        },
                      ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, Quest quest) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informacje o misji').tr(),
          content: Text(quest.details).tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK').tr(),
            ),
          ],
        );
      },
    );
  }

  void _showRewardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Odbierz nagrodę').tr(),
          content: Text('Gratulacje! Odbierasz nagrodę.').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK').tr(),
            ),
          ],
        );
      },
    );
  }
}

class Quest {
  final String title;
  final String description;
  final String category;
  final String details;
  bool isInfoAvailable;
  bool isCompleted;

  Quest(this.title, this.description, this.category, this.details,
      {this.isInfoAvailable = false, this.isCompleted = false});
}

final List<Quest> availableQuests = [
  Quest('Tytuł Misji 1', 'Krótki opis misji 1', 'Misje Gildijne',
      'Szczegóły misji 1',
      isInfoAvailable: true, isCompleted: false),
  Quest('Tytuł Misji 2', 'Krótki opis misji 2', 'Misje Lokalnych Klientów',
      'Szczegóły misji 2',
      isInfoAvailable: true, isCompleted: false),
  Quest('Tytuł Misji 3', 'Krótki opis misji 3', 'Misje Wydarzeniowe',
      'Szczegóły misji 3',
      isInfoAvailable: true, isCompleted: false),
  Quest('Tytuł Misji 4', 'Krótki opis misji 4', 'Misje Dzienne i Tygodniowe',
      'Szczegóły misji 4',
      isInfoAvailable: true, isCompleted: true),
  Quest('Tytuł Misji 5', 'Krótki opis misji 5', 'Misje Gildijne',
      'Szczegóły misji 5',
      isInfoAvailable: true, isCompleted: true),
];