class Character {
  final int id;
  final String name;
  int level;
  String avatarPath;
  bool bussy;
  bool isRested;
  bool hasSupplies;

  Character(
      {required this.id,
      required this.name,
      required this.level,
      required this.avatarPath,
      required this.bussy,
      required this.isRested,
      required this.hasSupplies});
}
