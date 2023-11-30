class Item {
  String name;
  int quantity;
  ItemType type;
  double weight;

  Item(this.name, this.quantity, this.type, this.weight);
}

enum ItemType {
  food,
  healthPotion,
  manaPotion,
  specialItem,
  swords,
  armor,
  weapon
}
