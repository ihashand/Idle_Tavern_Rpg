import 'package:flutter/material.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/employees_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_data/player_one_data.dart';
import 'package:game_template/src/temporary_database/tavern/tavern_models/employee.dart';

class PersonnelScreen extends StatefulWidget {
  const PersonnelScreen({Key? key}) : super(key: key);

  @override
  PersonnelScreenState createState() => PersonnelScreenState();
}

class PersonnelScreenState extends State<PersonnelScreen> {
  Employee? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personnel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Hired Personnel:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildEmployeeGrid(true),
              SizedBox(height: 20),
              Text(
                'Available Personnel:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildEmployeeGrid(false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeGrid(bool hired) {
    List<Employee> filteredEmployees = hired
        ? employees.where((employee) => employee.isHired).toList()
        : employees.where((employee) => !employee.isHired).toList();

    Map<EmployeeCategory, List<Employee>> groupedEmployees =
        _groupEmployeesByCategory(filteredEmployees);

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: EmployeeCategory.values.length,
      itemBuilder: (context, index) {
        EmployeeCategory category = EmployeeCategory.values[index];
        List<Employee> categoryEmployees = groupedEmployees[category] ?? [];

        return ExpansionTile(
          initiallyExpanded:
              true, // Make the ExpansionTile initially uncollapsed
          title: Text(
            category.toString().split('.').last,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.2,
              ),
              itemCount: categoryEmployees.length,
              itemBuilder: (context, subIndex) {
                Employee employee = categoryEmployees[subIndex];
                return GestureDetector(
                  onTap: () {
                    _showDetailsModal(employee);
                  },
                  child: Container(
                    width: 100.0,
                    child: Column(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(employee.iconUrl),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          employee.name,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Map<EmployeeCategory, List<Employee>> _groupEmployeesByCategory(
      List<Employee> employees) {
    Map<EmployeeCategory, List<Employee>> groupedMap = {};
    for (var category in EmployeeCategory.values) {
      groupedMap[category] =
          employees.where((employee) => employee.category == category).toList();
    }
    return groupedMap;
  }

  void _showDetailsModal(Employee employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(employee.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Category: ${employee.category.toString().split('.').last}'),
                      Text('Skill: ${employee.skill}'),
                      Text('Payment: ${employee.payment}'),
                    ],
                  ),
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(employee
                            .iconUrl), // Use AssetImage for local assets
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (employee.isHired)
                  ElevatedButton(
                    onPressed: () {
                      _fireEmployee(employee);
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: Text('Fire'),
                  ),
                if (!employee.isHired)
                  ElevatedButton(
                    onPressed: () {
                      if (player_one.gold >= employee.payment) {
                        _hireEmployee(employee);
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        _showNotEnoughGoldDialog();
                      }
                    },
                    child: Text('Hire'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hireEmployee(Employee employee) {
    setState(() {
      player_one.gold -= employee.payment;
      employee.isHired = true;
    });
  }

  void _fireEmployee(Employee employee) {
    setState(() {
      employee.isHired = false;
    });
  }

  void _showNotEnoughGoldDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not Enough Gold',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('You do not have enough gold to hire this employee.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
