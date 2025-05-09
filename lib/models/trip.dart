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
  DateTime? get startDate =>
      tripPoints.isNotEmpty ? tripPoints.first.startDate : null;
  DateTime? get endDate => tripPoints.last.endDate;
  void archiveTripToggle() {
    archived = !archived;
  }

  void updateTitle(String newTitle) {
    title = newTitle;
  }
}
