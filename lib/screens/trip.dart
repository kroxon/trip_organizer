import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/screens/point_of_trip.dart';
import 'package:trip_organizer/widgets/check_list_dialog.dart';
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
  Trip? trip;

  void _showChecklistDialog(BuildContext context) async {
    final List<String> checklistItems = [
      'Opcja 1',
      'Opcja 2',
      'Opcja 3',
      'Opcja 4',
    ];
    final List<bool> initialValues = List.generate(
      checklistItems.length,
      (index) => false,
    );

    final result = await showDialog<List<bool>>(
      context: context,
      builder: (BuildContext context) {
        return ChecklistAlertDialog(
          items: checklistItems,
          initialCheckedItems: initialValues,
          onChecklistChanged: (List<bool> updatedCheckedItems) {
            // Handle changes here if needed
            setState(() {
              // Update your checklist state here
            });
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        // Update the trip's checklist based on result
        for (int i = 0; i < result.length; i++) {
          trip?.checklist[i].isChecked = result[i];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip != null ? trip!.title : 'New Trip'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (trip != null)
              GestureDetector(
                onTap: () {
                  _showChecklistDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('List of things to take',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    )),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                                '${trip!.completedChecklistItems}/${trip!.totalChecklistItems} items packed',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    )),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/luggage2.png',
                                width: 50,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            Row(
              children: [Text('Tickets')],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: trip != null && trip!.tripPoints.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trip!.tripPoints.length,
                      itemBuilder: (ctx, index) {
                        final tripPoint = trip!.tripPoints[index];
                        return TripPointCard(
                          tripPoint: tripPoint,
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
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No points added yet.'),
                      ),
                    ),
            ),
          ],
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
