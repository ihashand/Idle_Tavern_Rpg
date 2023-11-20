class Character {
  final String name;
  final CharacterCategory category;
  final int level;
  final int
      skill; //todo przerobic na oddzielna klase w przyszlosci okreslajace bohatera
  final int payment;
  final String iconUrl;
  final isAvailable = true;
  bool isBusy = false;

  Character(
      {required this.name,
      required this.category,
      required this.level,
      required this.skill,
      required this.payment,
      required this.iconUrl});
}

enum CharacterCategory {
  Paladin,
  Rogue,
  Diplomat,
  Warrior,
  Mage,
  Hunter,
  Priest,
  Sorcerer,
  Assassin,
  Alchemist
}
