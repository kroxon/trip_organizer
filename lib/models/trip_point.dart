class TripPoint {
  final String place;
  final DateTime date;
  final List<String>? ticketUrls;
  final String? notes;
  final String? googleMapsUrl;
  final List<String>? links;
  final String? weather;

  TripPoint({
    required this.place,
    required this.date,
    this.ticketUrls,
    this.notes,
    this.googleMapsUrl,
    this.links,
    this.weather,
  });
}
