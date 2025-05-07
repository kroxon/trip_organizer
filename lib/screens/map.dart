import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

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
  Future<void> _openNavigation() async {
    final double latitude = widget.location.latitude;
    final double longitude = widget.location.longitude;
    Uri googleMapsUrl;

    if (Platform.isAndroid) {
      googleMapsUrl =
          Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot open navigation on this platform.')),
      );
      return;
    }

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot open navigation.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.location.place)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openNavigation,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
