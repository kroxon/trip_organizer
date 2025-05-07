import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/screens/map.dart';

class MapImage extends StatelessWidget {
  const MapImage({super.key, required this.location});

  final TripPointLocation location;

  String get locationImage {
    final lat = location.latitude;
    final lng = location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=${dotenv.env['YOUR_GOOGLE_API_KEY']}';
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Image.network(
      locationImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MapScreen(location: location),
              ),
            );
          },
          child: Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
              ),
            ),
            child: previewContent,
          ),
        ),
      ],
    );
  }
}
