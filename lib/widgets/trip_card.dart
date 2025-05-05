import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_organizer/models/trip.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  final Trip trip;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formattedDate = DateFormat('dd.MM.yyyy').format(trip.startDate);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: colorScheme.surfaceContainerHigh,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      color: colorScheme.primary, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.wb_sunny_outlined,
                      color: colorScheme.tertiary, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(
                    trip.weather ?? 'Unknown',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    trip.completedChecklistItems == trip.totalChecklistItems
                        ? Icons.check_circle_outline
                        : Icons.playlist_add_check_outlined,
                    color: trip.completedChecklistItems == trip.totalChecklistItems
                        ? colorScheme.secondary
                        : colorScheme.onSurfaceVariant,
                    size: 16.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '${trip.completedChecklistItems} / ${trip.totalChecklistItems} of the items collected',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
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
