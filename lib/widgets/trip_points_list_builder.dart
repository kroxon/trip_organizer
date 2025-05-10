import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/services/firestore_service.dart';
import 'package:trip_organizer/screens/point_of_trip.dart';
import 'package:trip_organizer/widgets/trip_point_card.dart';

class TripPointsListBuilder extends StatelessWidget {
  final Trip trip;

  const TripPointsListBuilder({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripPoint>>(
      stream: FirestoreService(context).getTripPoints(trip.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No points added yet.'));
        }

        final tripPoints = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tripPoints.length,
          itemBuilder: (ctx, index) {
            final tripPoint = tripPoints[index];
            return Dismissible(
              key: Key(tripPoint.id!),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Point of Trip'),
                      content: const Text(
                          'Are you sure you want to delete this point of trip?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                FirestoreService(context).deleteTripPoint(trip.id!, tripPoints[index].id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Point of trip deleted.'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        FirestoreService(context)
                            .addTripPoint(trip.id!, tripPoint);
                      },
                    ),
                  ),
                );
              },
              child: TripPointCard(
                tripPoint: tripPoint,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PointOfTripScreen(
                        trip: trip,
                        tripPoint: tripPoint,
                        isEditing: false,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
