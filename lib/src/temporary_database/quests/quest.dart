final class Quest {
  final String title;
  final String description;
  final String category;
  final String details;
  bool isInfoAvailable;
  bool isCompleted;

  Quest(this.title, this.description, this.category, this.details,
      {this.isInfoAvailable = false, this.isCompleted = false});
}
