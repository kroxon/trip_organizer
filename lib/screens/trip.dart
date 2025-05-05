import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/screens/point_of_trip.dart';
import 'package:trip_organizer/widgets/floating_action_btn.dart';
import 'package:trip_organizer/widgets/trip_point_card.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key, this.trip, required this.isEditing});

  final Trip? trip;
  final bool isEditing;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: widget.trip?.tripPoints.length,
          itemBuilder: (ctx, index) {
            final tripPoint = widget.trip?.tripPoints[index];
            return TripPointCard(
              tripPoint: tripPoint!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PointOfTripScreen(
                      tripPoint: tripPoint,
                      isEditing: false,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        label: 'New Point',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PointOfTripScreen(isEditing: true),
            ),
          );
        },
      ),
    );
  }
}
