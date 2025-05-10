import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/services/firestore_service.dart';
import 'package:trip_organizer/widgets/trip_point_card.dart';

class TripPointsListBuilder extends StatefulWidget {
  const TripPointsListBuilder({super.key, required this.tripId});

  final String tripId;

  @override
  State<StatefulWidget> createState() {
    return _TripListBuilderState();
  }
}

class _TripListBuilderState extends State<TripPointsListBuilder> {
  late final FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(context);
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<TripPoint>>(
      stream: firestoreService.getTripPoints(widget.tripId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('There are no trip points yet.'));
        }

        final tripPoints = snapshot.data!;
        return ListView.builder(
          itemCount: tripPoints.length,
          itemBuilder: (ctx, index) {
            final TripPoint tripPoint = tripPoints[index];
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
                        title: const Text('Delete Trip Point'),
                        content: const Text(
                            'Are you sure you want to delete this trip point?'),
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
                  firestoreService.deleteTripPoint(widget.tripId, tripPoint.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Trip point deleted'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          firestoreService.addTripPoint(widget.tripId, tripPoint);
                        },
                      ),
                    ),
                  );
                },
                child: TripPointCard(tripPoint: tripPoint));
          },
        );
      },
    );
  }
}
