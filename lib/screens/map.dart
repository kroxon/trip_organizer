import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_organizer/models/trip_point.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.location,
  });

  final TripPointLocation location;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.location.place), actions: [
        IconButton(
          icon: const Icon(Icons.navigation),
          onPressed: () {},
        ),
      ]),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: LatLng(
              widget.location.latitude,
              widget.location.longitude,
            ),
          ),
        },
      ),
    );
  }
}
