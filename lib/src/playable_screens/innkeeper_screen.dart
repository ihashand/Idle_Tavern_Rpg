import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/employee.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/employees_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/inventory_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/item.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/main_prestige_level.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/main_prestige_level_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/player.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';

class InnkeeperScreen extends StatefulWidget {
  const InnkeeperScreen({super.key});

  @override
  _InnkeeperState createState() => _InnkeeperState();
}

//Temporary data, ill move it aft workint /patrys
Map<String, int> earnings = {'Quests': 200, 'Tavern Sales': 300};
int innLevel = 1;

class _InnkeeperState extends State<InnkeeperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Innkeeper'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PlayerInfoSection(
                player_one), // there is second for test named player_two
            EmployeeManagementSection(employees),
            PrestigeLevelSection(mainPrestigeLevel),
            InnExpansionSection(innLevel),
            InventorySection(inventory),
            EarningsSection(earnings),
          ],
        ),
      ),
    );
  }
}

class PlayerInfoSection extends StatelessWidget {
  final Player player;
  const PlayerInfoSection(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Player Information',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text('Player ID: ${player.id}'),
          Text('Gold: ${player.gold}'),
          Text('Diamonds: ${player.diamonds}'),
        ],
      ),
    );
  }
}

class EmployeeManagementSection extends StatelessWidget {
  final List<Employee> employees;
  const EmployeeManagementSection(this.employees, {super.key});

  void hireEmployee(Employee employee) {
    // Logic for hiring an employee
  }

  void fireEmployee(Employee employee) {
    // Logic for firing an employee
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Employee Management',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          // Add an interface for managing employees, such as a list of employees, buttons for hiring and firing
        ],
      ),
    );
  }
}

class PrestigeLevelSection extends StatelessWidget {
  const PrestigeLevelSection(MainPrestigeLevel mainPrestigeLevel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Main prestige level = ${mainPrestigeLevel.prestige.toString()}\n Human = ${mainPrestigeLevel.prestigesLeves[0].prestige}\nOrcs = ${mainPrestigeLevel.prestigesLeves[1].prestige}",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )

          // Add an interface to display prestige levels, such as a list for different races.
        ],
      ),
    );
  }
}

class InnExpansionSection extends StatelessWidget {
  final int innLevel;
  const InnExpansionSection(this.innLevel, {super.key});

  void expandInn(int newLevel) {
    // Logic to expand the inn
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inn Expansion',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text('Current Inn Level: $innLevel'),
          ElevatedButton(
            onPressed: () {
              expandInn(innLevel + 1);
            },
            child: Text('Expand Inn'),
          ),
          // Add more interface to inn expansion
        ],
      ),
    );
  }
}

class InventorySection extends StatelessWidget {
  final List<Item> inventory;
  const InventorySection(this.inventory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Inventory',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          // Add an interface for inventory management, such as a list of items
        ],
      ),
    );
  }
}

class EarningsSection extends StatelessWidget {
  final Map<String, int> earnings;
  const EarningsSection(this.earnings, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Earnings',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          // Add an interface to display earnings information, such as a list of earnings sources.
        ],
      ),
    );
  }
}
