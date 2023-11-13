import '../tavern/tavern_models/item.dart';

final class Quest {
  final String id;
  final String title;
  final String description;
  final String category;
  final String details;
  bool isInfoAvailable;
  bool isCompleted;
  List<Item> items;

  Quest(this.id, this.title, this.description, this.category, this.details,
      this.items,
      {this.isInfoAvailable = false, this.isCompleted = false});
}
