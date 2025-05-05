import 'package:trip_organizer/models/checklist_item.dart';
import 'package:trip_organizer/models/trip_point.dart';

class Trip {
  final String title;
  final List<ChecklistItem> checklist;
  final DateTime startDate;
  final String? weather;
  final List<TripPoint> tripPoints;

  Trip({
    required this.title,
    required this.checklist,
    required this.startDate,
    this.weather,
    required this.tripPoints,
  });

  bool get isChecklistComplete => checklist.every((item) => item.isChecked);
  int get completedChecklistItems =>
      checklist.where((item) => item.isChecked).length;
  int get totalChecklistItems => checklist.length;
}
