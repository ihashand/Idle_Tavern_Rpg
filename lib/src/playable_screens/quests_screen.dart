import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/playable_screens/expeditions/expeditions_screen.dart';
import 'package:game_template/src/temporary_database/quests/available_quests_data.dart';
import 'package:game_template/src/temporary_database/quests/quest.dart';
import 'package:game_template/src/temporary_database/quests/reward.dart';
import 'dart:async';
import 'package:game_template/src/temporary_database/quests/rewards_data.dart';
import 'package:provider/provider.dart';
import '../../game_state.dart';
import '../temporary_database/quests/categories_data.dart';
import '../temporary_database/tavern/tavern_models/item.dart';

// Define the QuestsScreen widget
class QuestsScreen extends StatefulWidget {
  @override
  _QuestsScreenState createState() => _QuestsScreenState();
}

late GameState gameState;

@override

// Define the state for the QuestsScreen widget
class _QuestsScreenState extends State<QuestsScreen> {
  // Variables to manage state and data
  String selectedCategory = 'All';
  int _selectedIndex = 0;
  bool wheelOfFortuneAvailable = true;
  String wheelOfFortuneResult = '';
  String newDay = "";
  int spinsRemaining = 7;
  bool wheelSpinAllowed = true;
  Timer? _dailyResetTimer;

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    int currentDay = Provider.of<GameState>(context, listen: false).currentDay;
    return Scaffold(
      // App bar with navigation and options
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          // Popup menu for selecting quest categories
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
          // Button to add a new day
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
          // Display current day
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
          // Button to access the wheel of fortune
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
      // List of quests
      body: ListView(
        children: <Widget>[
          // Display quests based on selected category
          for (var quest in availableQuests)
            if (selectedCategory == 'All' || quest.category == selectedCategory)
              ListTile(
                title: Text(quest.title),
                subtitle: Text(quest.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Button to show quest information
                    if (quest.isInfoAvailable)
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          _showInfoDialog(context, quest as Quest);
                        },
                      ),
                    // Button to claim quest reward
                    if (quest.isCompleted)
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          _claimQuest(quest, context);
                          _showRewardDialogQuest(context);
                          removeQuest(quest.id);
                        },
                      ),
                  ],
                ),
              ),
        ],
      ),
      // Bottom navigation bar for app navigation
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
          // Navigate based on the selected index
          if (index == 0) {
            Navigator.pop(context);
          } else {
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpeditionsScreen()),
                );
                break;
            }
          }
        },
      ),
    );
  }

  // Initialize state and timers
  @override
  void initState() {
    super.initState();
    gameState = Provider.of<GameState>(context, listen: false);
    _generateRewards();
    _startDailyResetTimer();
  }

  // Reset and shuffle rewards when the timer triggers
  void _resetAndShuffleRewards() {
    gameState = Provider.of<GameState>(context, listen: false);

    _generateRewards();
    rewards.shuffle();
    gameState.updateDaysSpun(List.generate(7, (index) => false));
  }

  // Start the daily reset timer
  void _startDailyResetTimer() {
    const oneDay = Duration(days: 1);
    _dailyResetTimer = Timer.periodic(oneDay, (timer) {
      if (mounted) {
        _resetAndShuffleRewards();
      }
    });
  }

  // Dispose of the timer when the widget is removed
  @override
  void dispose() {
    _dailyResetTimer?.cancel();
    super.dispose();
  }

  // Generate rewards based on the current day
  void _generateRewards() {
    for (int i = 0; i < rewards.length; i++) {
      if (gameState.currentDay <= 3 && rewards[i].value == 1) {
        rewards[i] = Reward(rewards[i].name, 1, rewards[i].item);
      } else if (gameState.currentDay <= 6 && rewards[i].value == 2) {
        rewards[i] = Reward(rewards[i].name, 2, rewards[i].item);
      } else if (gameState.currentDay == 7 && rewards[i].value == 3) {
        rewards[i] = Reward(rewards[i].name, 3, rewards[i].item);
      }
    }
    rewards.shuffle();
    rewards.sort((a, b) => a.value.compareTo(b.value));
  }

  // Add a new day and update the UI
  String _addDay() {
    gameState.incrementDay();
    setState(() {
      newDay = gameState.currentDay.toString();
    });
    return newDay;
  }

  // Show a dialog if the reward for the current day has already been claimed
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

  // Show a dialog if a day was skipped
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

  // Reset the day counter to one
  void _resetDayCounter() {
    setState(() {
      gameState.currentDay = 1;
    });
    _resetAndShuffleRewards();
  }

  // Show a dialog with quest information
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

  // Show a dialog with the claimed reward
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

  // Show a dialog for claiming quest rewards
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

  // Show a bottom sheet with dice menu options
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
                  title: Text('Get reward'),
                  onTap: () {
                    _spinWheelOfFortune();
                  },
                ),
                Divider(),
                Text('Last 7 days:'),
                for (int i = 0; i < 7; i++)
                  ListTile(
                    title: Text('Day ${i + 1}'),
                    trailing: gameState.daysSpun[i]
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

  void _spinWheelOfFortune() {
    // Check if the current day's reward has already been claimed
    if (!gameState.daysSpun[gameState.currentDay - 1]) {
      final reward = rewards[gameState.currentDay - 1];

      // Check if a previous day was skipped
      if (gameState.currentDay > 1 &&
          !gameState.daysSpun[gameState.currentDay - 2]) {
        _showSkippedDayDialog();
        _resetAndShuffleRewards();
        _resetDayCounter();
      } else {
        // Claim the reward for the current day
        if (!gameState.daysSpun[gameState.currentDay - 1]) {
          _claimReward(reward, context);
          _showRewardDialog(context, reward);
          gameState.daysSpun[gameState.currentDay - 1] = true;

          // Check if all rewards have been claimed
          if (gameState.daysSpun.every((day) => day)) {
            _resetDayCounter();
            _resetAndShuffleRewards();
          }
        } else {
          _showAlreadyClaimedDialog();
        }
      }

      // Here, generate your wheel of fortune result
      String wheelResult = "";
      gameState.spinWheelOfFortune(
          wheelResult); // Update wheel of fortune result in GameState
    } else {
      _showAlreadyClaimedDialog();
    }
  }

  void _claimQuest(Quest quest, BuildContext context) {
    Item item = quest.items[0];
    Provider.of<GameState>(context, listen: false).addItemToInventory(item);
  }

  void _claimReward(Reward reward, BuildContext context) {
    Item item = reward.item;
    Provider.of<GameState>(context, listen: false).addItemToInventory(item);
  }

  void removeQuest(String questId) {
    availableQuests.removeWhere((quest) => quest.id == questId);
    setState(() {});
  }
}
