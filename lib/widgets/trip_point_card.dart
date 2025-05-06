import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip_point.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tripPoint.tripPointLocation.place,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.primary, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(
                    tripPoint.googleMapsUrl ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
