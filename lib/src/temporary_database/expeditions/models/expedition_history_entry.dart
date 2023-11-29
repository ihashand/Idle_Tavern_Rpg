class ExpeditionHistoryEntry {
  String expeditionName;
  DateTime date;
  String description;
  String outcome;
  int earnedGold;
  int duration;
  List<Map<String, dynamic>> specialEventsDetails;

  ExpeditionHistoryEntry(
    this.expeditionName,
    this.date,
    this.description,
    this.outcome,
    this.earnedGold,
    this.duration,
    this.specialEventsDetails,
  );
}
