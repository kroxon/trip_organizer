import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripPointLocation {
  const TripPointLocation({
    required this.latitude,
    required this.longitude,
    required this.place,
  });

  final double latitude;
  final double longitude;
  final String place;

  String get locationImage {
    final lat = latitude;
    final lng = longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=${dotenv.env['YOUR_GOOGLE_API_KEY']}';
  }
}

class TripPoint {
  final TripPointLocation tripPointLocation;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String>? ticketUrls;
  final String? notes;

  TripPoint({
    required this.tripPointLocation,
    required this.startDate,
    this.endDate,
    this.ticketUrls,
    this.notes,
  });

  String get formattedStartDate {
    return '${startDate.day}.${startDate.month}.${startDate.year}';
  }

  String get formattedEndDate {
    if (endDate == null) {
      return '';
    }
    return '${endDate!.day}.${endDate!.month}.${endDate!.year}';
  }
}
