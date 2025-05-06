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
    weather: 'Sunny, 22°C',
    tripPoints: [
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 45.1234,
          longitude: -121.5678,
          place: 'Mountain Trailhead',
        ),
        startDate: DateTime(2025, 6, 15, 9, 0),
        weather: 'Moderate difficulty trail, 4 hours',
      ),
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 45.1234,
          longitude: -121.5678,
          place: 'Scenic Viewpoint',
        ),
        startDate: DateTime(2025, 6, 15, 13, 0),
        endDate: DateTime(2025, 6, 15, 14, 0),
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
    weather: 'Cloudy, 19°C',
    tripPoints: [
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 48.8566,
          longitude: 2.3522,
          place: 'Eiffel Tower',
        ),
        startDate: DateTime(2025, 7, 1, 10, 0),
        endDate: DateTime(2025, 7, 1, 12, 0),
        weather: 'Book tickets in advance',
      ),
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 48.8566,
          longitude: 2.3522,
          place: 'Louvre Museum',
        ),
        startDate: DateTime(2025, 7, 1, 14, 0),
        weather: 'Guided tour',
      ),
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 48.8566,
          longitude: 2.3522,
          place: 'Notre-Dame Cathedral',
        ),
        startDate: DateTime(2025, 7, 1, 16, 0),
        endDate: DateTime(2025, 10, 1, 17, 0),
        weather: 'Explore the area',
      ),
    ],
  ),
];