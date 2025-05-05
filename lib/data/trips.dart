import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/models/checklist_item.dart';
import 'package:trip_organizer/models/trip_point.dart';

final List<Trip> sampleTrips = [
  Trip(
    title: 'Mountain Weekend',
    checklist: [
      ChecklistItem(name: 'Hiking boots', isChecked: false),
      ChecklistItem(name: 'Water bottle', isChecked: true),
      ChecklistItem(name: 'First aid kit', isChecked: false),
    ],
    startDate: DateTime(2025, 6, 15),
    weather: 'Sunny, 22°C',
    tripPoints: [
      TripPoint(
        place: 'Mountain trail hiking',
        date: DateTime(2025, 6, 15, 9, 0),
        weather: 'Moderate difficulty trail, 4 hours',
      ),
      TripPoint(
        place: 'Picnic lunch',
        date: DateTime(2025, 6, 15, 13, 0),
        weather: 'Rest at viewpoint',
      ),
    ],
  ),
  Trip(
    title: 'City Break in Paris',
    checklist: [
      ChecklistItem(name: 'Passport', isChecked: true),
      ChecklistItem(name: 'Camera', isChecked: true),
      ChecklistItem(name: 'Travel adapter', isChecked: false),
    ],
    startDate: DateTime(2025, 7, 1),
    weather: 'Cloudy, 19°C',
    tripPoints: [
      TripPoint(
        place: 'Eiffel Tower visit',
        date: DateTime(2025, 7, 1, 10, 0),
        weather: 'Book tickets in advance',
      ),
      TripPoint(
        place: 'Louvre Museum',
        date: DateTime(2025, 7, 1, 14, 0),
        weather: 'Guided tour',
      ),
    ],
  ),
];