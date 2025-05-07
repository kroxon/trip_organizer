import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/screens/map.dart';

class MapImage extends StatelessWidget {
  const MapImage({super.key, required this.location});

  final TripPointLocation location;

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Image.network(
      location.locationImage,
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
