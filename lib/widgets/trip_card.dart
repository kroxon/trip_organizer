import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/widgets/weather_container.dart';

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

    String formatterDate(DateTime date) {
      return DateFormat('dd.MM.yyyy').format(date);
    }

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
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 24.0),
                            if (trip.tripPoints.isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      color: colorScheme.primary, size: 16.0),
                                  const SizedBox(width: 4.0),
                                  Flexible(
                                    child: Text(
                                      formatterDate(trip.startDate!),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (trip.endDate != null) ...[
                                    const SizedBox(width: 8.0),
                                    Icon(Icons.calendar_today_outlined,
                                        color: colorScheme.primary, size: 16.0),
                                    const SizedBox(width: 4.0),
                                    Flexible(
                                      child: Text(
                                        formatterDate(trip.endDate!),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Icon(
                                  trip.completedChecklistItems ==
                                          trip.totalChecklistItems
                                      ? Icons.check_circle_outline
                                      : Icons.playlist_add_check_outlined,
                                  color: trip.completedChecklistItems ==
                                          trip.totalChecklistItems
                                      ? colorScheme.secondary
                                      : colorScheme.onSurfaceVariant,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 4.0),
                                Flexible(
                                  child: Text(
                                    '${trip.completedChecklistItems} / ${trip.totalChecklistItems} of the items collected',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (trip.tripPoints.isNotEmpty)
                      Expanded(
                        flex: 1,
                        child:
                            WeatherContainer(tripPoint: trip.tripPoints.first),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
