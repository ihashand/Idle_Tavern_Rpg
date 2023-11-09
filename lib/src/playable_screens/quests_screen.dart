import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/tavern_screen.dart';
import 'package:game_template/src/temporary_database/quests/available_quests_data.dart';
import 'package:game_template/src/temporary_database/quests/categories_data.dart';
import 'package:game_template/src/temporary_database/quests/quest.dart';
import 'package:game_template/src/temporary_database/quests/reward.dart';
import 'dart:async';

import 'package:game_template/src/temporary_database/quests/rewards_data.dart';

class QuestsScreen extends StatefulWidget {
  @override
  _QuestsScreenState createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  String selectedCategory = 'All';
  int _selectedIndex = 0;

  bool wheelOfFortuneAvailable = true;
  String wheelOfFortuneResult = '';
  String newDay = "";
  int currentDay = 1;
  int spinsRemaining = 7;
  bool wheelSpinAllowed = true;
  List<bool> daysSpun = List.generate(7, (index) => false);

  Timer? _dailyResetTimer;

  @override
  void initState() {
    super.initState();
    _generateRewards();
    _startDailyResetTimer();
  }

  void _resetAndShuffleRewards() {
    _generateRewards();
    rewards.shuffle();
    setState(() {
      daysSpun = List.generate(7, (index) => false);
    });
  }

  void _startDailyResetTimer() {
    const oneDay = Duration(days: 1);
    _dailyResetTimer = Timer.periodic(oneDay, (timer) {
      if (mounted) {
        _resetAndShuffleRewards();
      }
    });
  }

  @override
  void dispose() {
    _dailyResetTimer?.cancel(); // Anuluj timer przed usunięciem widgetu
    super.dispose();
  }

  void _generateRewards() {
    // Assign rewards based on the current day
    for (int i = 0; i < rewards.length; i++) {
      if (currentDay <= 3 && rewards[i].value == 1) {
        rewards[i] = Reward(rewards[i].name, 1);
      } else if (currentDay <= 6 && rewards[i].value == 2) {
        rewards[i] = Reward(rewards[i].name, 2);
      } else if (currentDay == 7 && rewards[i].value == 3) {
        rewards[i] = Reward(rewards[i].name, 3);
      }
    }

    // Shuffle rewards
    rewards.shuffle();

    // Sort rewards from least valuable to most valuable
    rewards.sort((a, b) => a.value.compareTo(b.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  child: Text(category),
                );
              }).toList();
            },
            child: Container(
              height: 20,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                selectedCategory,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _addDay();
                },
                child: Text('+'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Day $currentDay",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.casino),
                onPressed: () {
                  _showDiceMenu();
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          for (var quest in availableQuests)
            if (selectedCategory == 'All' || quest.category == selectedCategory)
              ListTile(
                title: Text(quest.title),
                subtitle: Text(quest.description),
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
                          _showRewardDialogQuest(context);
                        },
                      ),
                  ],
                ),
              ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'back'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'tavern'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pop(context);
          } else {
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TavernScreen()),
                );
                break;
            }
          }
        },
      ),
    );
  }

  String _addDay() {
    setState(() {
      currentDay = (currentDay % 7) + 1;
      newDay = currentDay.toString();
    });
    return newDay;
  }

  void _spinWheelOfFortune() {
    if (!daysSpun[currentDay - 1]) {
      final reward = rewards[currentDay - 1];

      if (currentDay > 1 && !daysSpun[currentDay - 2]) {
        _showSkippedDayDialog();
        _resetAndShuffleRewards();
        _resetDayCounter();
      } else {
        if (!daysSpun[currentDay - 1]) {
          _showRewardDialog(context, reward);
          daysSpun[currentDay - 1] = true;

          // Sprawdź, czy wszystkie nagrody zostały już odebrane
          if (daysSpun.every((day) => day)) {
            _resetDayCounter();
            _resetAndShuffleRewards();
          }
        } else {
          _showAlreadyClaimedDialog();
        }
      }
    } else {
      _showAlreadyClaimedDialog();
    }
  }

  void _showAlreadyClaimedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning').tr(),
          content: Text('Reward for this day has already been claimed.').tr(),
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

  void _showSkippedDayDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning').tr(),
          content: Text('Skipped a day. Returning to day one.').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetDayCounter();
              },
              child: Text('OK').tr(),
            ),
          ],
        );
      },
    );
  }

  void _resetDayCounter() {
    setState(() {
      currentDay = 1;
    });
    _resetAndShuffleRewards();
  }

  void _showInfoDialog(BuildContext context, Quest quest) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mission Information').tr(),
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

  void _showRewardDialog(BuildContext context, Reward reward) async {
    Navigator.of(context).pop();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Claim Reward').tr(),
          content: Text('Congratulations! You receive ${reward.name}.').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDiceMenu();
              },
              child: Text('OK').tr(),
            ),
          ],
        );
      },
    );
  }

  void _showRewardDialogQuest(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Claim Reward').tr(),
          content: Text('Congratulations!').tr(),
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

  void _showDiceMenu() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Spin for Reward'),
                  onTap: () {
                    _spinWheelOfFortune();
                  },
                ),
                Divider(),
                Text('Last 7 days:'),
                for (int i = 0; i < 7; i++)
                  ListTile(
                    title: Text('Day ${i + 1}'),
                    trailing: daysSpun[i]
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel, color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
