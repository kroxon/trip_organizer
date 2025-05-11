import 'package:trip_organizer/models/checklist_item.dart';
import 'package:trip_organizer/models/trip_point.dart';

class Trip {
  Trip({
    this.id,
    required this.title,
    required this.checklist,
    required this.tripPoints,
    this.archived = false,
  });

  String? id;
  String title;
  final List<ChecklistItem> checklist;
  final List<TripPoint> tripPoints;
  bool archived = false;

  bool get isChecklistComplete => checklist.every((item) => item.isChecked);
  int get completedChecklistItems =>
      checklist.where((item) => item.isChecked).length;
  int get totalChecklistItems => checklist.length;
  DateTime? get startDate {
    if (tripPoints.isEmpty) return null;
    return tripPoints
        .map((point) => point.startDate)
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }
  DateTime? get endDate {
    if (tripPoints.isEmpty) return null;
    final endDates = tripPoints
        .map((point) => point.endDate)
        .where((date) => date != null)
        .cast<DateTime>()
        .toList();
    if (endDates.isEmpty) return null;
    return endDates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
  void archiveTripToggle() {
    archived = !archived;
  }

  void updateTitle(String newTitle) {
    title = newTitle;
  }
}
