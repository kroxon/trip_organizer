class TripPointLocation {
  const TripPointLocation({
    required this.latitude,
    required this.longitude,
    required this.place,
  });

  final double latitude;
  final double longitude;
  final String place;
}

class TripPoint {
  final TripPointLocation tripPointLocation;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String>? ticketUrls;
  final String? notes;
  final String? googleMapsUrl;
  final List<String>? links;
  final String? weather;

  TripPoint({
    required this.tripPointLocation,
    required this.startDate,
    this.endDate,
    this.ticketUrls,
    this.notes,
    this.googleMapsUrl,
    this.links,
    this.weather,
  });
}
