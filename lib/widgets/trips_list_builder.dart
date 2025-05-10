import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/screens/trip.dart';
import 'package:trip_organizer/services/firestore_service.dart';
import 'package:trip_organizer/widgets/trip_card.dart';

class TripListBuilder extends StatefulWidget {
  const TripListBuilder({super.key, required this.firestoreService});

    final FirestoreService firestoreService;


  @override
  State<TripListBuilder> createState() => _TripListBuilderState();
}

class _TripListBuilderState extends State<TripListBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trip>>(
      stream: widget.firestoreService.getAllTrips(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('There are no travels yet.'));
        }

        final trips = snapshot.data!;
        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (ctx, index) {
            final Trip trip = trips[index];
            return Dismissible(
              key: Key(trip.id!),
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
                      title: const Text('Delete Trip'),
                      content: const Text(
                          'Are you sure you want to delete this trip?'),
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
                widget.firestoreService.deleteTrip(trip.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${trip.title} deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        widget.firestoreService.addTrip(trip);
                      },
                    ),
                  ),
                );
              },
              child: TripCard(
                trip: trip,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripScreen(
                        trip: trip,
                        isNewTrip: false,
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
