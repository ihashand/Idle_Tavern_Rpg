class Item {
  String name;
  int quantity;
  ItemType type;
  double weight; // Opcjonalnie, jeśli chcesz uwzględniać wagę przedmiotów

  Item(this.name, this.quantity, this.type, this.weight);
}

enum ItemType {
  Food,
  HealthPotion,
  ManaPotion,
  SpecialItem,
  Swords
  // Specjalne przedmioty wymagane dla niektórych ekspedycji
  // Dodaj inne typy przedmiotów według potrzeb
}
