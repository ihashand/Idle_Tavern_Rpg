class ExpeditionHistoryEntry {
  String expeditionName;
  DateTime date;
  String description; // Dodane pole do przechowywania opisu wyprawy
  String outcome;
  int earnedGold; // Dodane pole do przechowywania zarobionego złota
  int duration; // Dodane pole do przechowywania czasu trwania wyprawy
  List<Map<String, dynamic>> specialEventsDetails;

  ExpeditionHistoryEntry(this.expeditionName, this.date, this.description,
      this.outcome, this.earnedGold, this.duration, this.specialEventsDetails);
}
