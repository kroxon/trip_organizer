import 'package:flutter/material.dart';
import 'package:trip_organizer/models/checklist_item.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/screens/point_of_trip.dart';
import 'package:trip_organizer/services/firestore_service.dart';
import 'package:trip_organizer/widgets/check_list_dialog.dart';
import 'package:trip_organizer/widgets/floating_action_btn.dart';
import 'package:trip_organizer/widgets/tickets_card.dart';
import 'package:trip_organizer/widgets/trip_point_card.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key, this.trip, required this.isNewTrip});

  final Trip? trip;
  final bool isNewTrip;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  Trip? trip;
  late bool isEditing;
  late TextEditingController _titleController;

  void _showChecklistDialog(BuildContext context) async {
    if (trip == null) return;

    final result = await showDialog<List<ChecklistItem>>(
      context: context,
      builder: (BuildContext context) {
        return ChecklistAlertDialog(
          checklistItems: trip!.checklist,
          onChecklistChanged: (List<ChecklistItem> updatedItems) {
            setState(() {
              trip!.checklist.clear();
              trip!.checklist.addAll(updatedItems);
            });
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        trip!.checklist.clear();
        trip!.checklist.addAll(result);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
    isEditing = widget.isNewTrip;
    _titleController =
        TextEditingController(text: !isEditing ? trip!.title : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_titleController.text.isNotEmpty) {
      setState(() {
        trip!.updateTitle(_titleController.text);
        isEditing = false;
      });
      final firestoreService = FirestoreService(context);
      firestoreService.updateTrip(trip!.id!, trip!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for the travel.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(trip!.title),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _onSubmit,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isEditing)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Trip Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _titleController.clear();
                      },
                    ),
                  ),
                ),
              ),
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
              children: [Expanded(child: TicketsCard())],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: trip != null && trip!.tripPoints.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trip!.tripPoints.length,
                      itemBuilder: (ctx, index) {
                        final sortedPoints = List.of(trip!.tripPoints)
                          ..sort((a, b) => a.startDate.compareTo(b.startDate));
                        final tripPoint = sortedPoints[index];
                        return TripPointCard(
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
              builder: (context) => PointOfTripScreen(
                isEditing: true,
                trip: trip,
              ),
            ),
          );
        },
      ),
    );
  }
}
