import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/screens/trip.dart';
import 'package:trip_organizer/services/firestore_service.dart';
import 'package:trip_organizer/widgets/floating_action_btn.dart';
import 'package:trip_organizer/widgets/main_drawer.dart';
import 'package:trip_organizer/widgets/trips_list_builder.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Travels'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [],
      ),
      drawer: MainDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: TripListBuilder(
        firestoreService: firestoreService,
      ),
      floatingActionButton: CustomFloatingActionButton(
        label: 'New Travel',
        onPressed: () async {
          Trip newTrip = Trip(
            title: 'New Trip',
            tripPoints: [],
            checklist: [],
          );
          await firestoreService.addTrip(newTrip);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripScreen(
                isNewTrip: false,
                trip: newTrip,
              ),
            ),
          ).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }
}
