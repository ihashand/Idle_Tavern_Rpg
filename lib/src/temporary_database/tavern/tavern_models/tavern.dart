class TavernUpgrade {
  String name;
  int level;
  int goldCost;

  TavernUpgrade(this.name, this.level, this.goldCost);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
      'goldCost': goldCost,
    };
  }

  factory TavernUpgrade.fromMap(Map<String, dynamic> map) {
    return TavernUpgrade(
      map['name'],
      map['level'],
      map['goldCost'],
    );
  }
}
