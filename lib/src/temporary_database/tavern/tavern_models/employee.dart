class Employee {
  late String name;
  late EmployeeCategory category;
  late int skill;
  late double payment;
  late String iconUrl;
  bool isHired = false;
  bool isAvailable = true;

  Employee({
    required this.name,
    required this.category,
    required this.skill,
    required this.payment,
    required this.iconUrl,
  });
}

enum EmployeeCategory {
  Waiter,
  Cook,
  Lumberjack,
  Cleaner,
}
