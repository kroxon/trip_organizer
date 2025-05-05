import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_organizer/data/trips.dart';
import 'package:trip_organizer/screens/trip_detail.dart';
import 'package:trip_organizer/widgets/floating_action_btn.dart';
import 'package:trip_organizer/widgets/main_drawer.dart';
import 'package:trip_organizer/widgets/trip_card.dart';

class TravelsScreen extends ConsumerStatefulWidget {
  const TravelsScreen({super.key});

  @override
  ConsumerState<TravelsScreen> createState() {
    return _TravelsScreenState();
  }
}

class _TravelsScreenState extends ConsumerState<TravelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Travels'), actions: [
        ],
      ),
      drawer: MainDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: ListView.builder(
          itemCount: sampleTrips.length,
          itemBuilder: (ctx, index) {
            final trip = sampleTrips[index];
            return TripCard(
              title: trip.title,
              startDate: trip.startDate,
              weather: trip.weather ?? 'Unknown',
              completedChecklistItems: trip.completedChecklistItems,
              totalChecklistItems: trip.totalChecklistItems,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailScreen(
                      trip: trip,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TripDetailScreen(isEditing: true),
            ),
          );
        },
      ),
    );
  }
}
