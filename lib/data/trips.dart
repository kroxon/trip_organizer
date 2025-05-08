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
  Trip(
    title: 'Beach Vacation',
    checklist: [
      ChecklistItem(name: 'Sunscreen', isChecked: true),
      ChecklistItem(name: 'Swimsuit', isChecked: false),
      ChecklistItem(name: 'Beach towel', isChecked: true),
    ],
    weather: 'Sunny, 30°C',
    tripPoints: [
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 36.7783,
          longitude: -119.4179,
          place: 'Beach Resort',
        ),
        // ustaw od 8 maja do 12 maja
        startDate: DateTime(2025, 5, 8, 10, 0),
        endDate: DateTime(2025, 5, 12, 18, 0),
        weather: 'Relax at the beach',
      ),
    ],
  ),
  Trip(
    title: 'Camping Trip',
    checklist: [
      ChecklistItem(name: 'Tent', isChecked: true),
      ChecklistItem(name: 'Sleeping bag', isChecked: false),
      ChecklistItem(name: 'Camping stove', isChecked: true),
    ],
    weather: 'Clear skies, 15°C',
    tripPoints: [
      TripPoint(
        tripPointLocation: TripPointLocation(
          latitude: 40.7128,
          longitude: -74.0060,
          place: 'Campsite',
        ),
        startDate: DateTime(2025, 5, 11, 10, 0),
        endDate: DateTime(2025, 5, 12, 12, 0),
        weather: 'Set up camp and relax',
      ),
    ],
  ),
];