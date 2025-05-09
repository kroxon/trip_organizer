import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/widgets/weather_container.dart';
import 'package:intl/intl.dart';

class TripPointCard extends StatelessWidget {
  const TripPointCard({
    super.key,
    required this.tripPoint,
    this.onTap,
  });

  final TripPoint tripPoint;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tripPoint.tripPointLocation.place,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${DateFormat('dd.MM.yyyy').format(tripPoint.startDate)}${tripPoint.endDate != null ? ' - ${DateFormat('dd.MM.yyyy').format(tripPoint.endDate!)}' : ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8), // Add spacing before weather container
              WeatherContainer(
                tripPoint: tripPoint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
