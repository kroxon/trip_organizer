import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/widgets/weather_container.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        color: colorScheme.surfaceContainerHigh,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tripPoint.tripPointLocation.place,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 22.0,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              tripPoint.formattedStartDate,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.onSurface),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (tripPoint.endDate != null) ...[
                            const SizedBox(width: 16.0),
                            Icon(
                              Icons.event_available,
                              size: 22.0,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4.0),
                            Flexible(
                              child: Text(
                                tripPoint.formattedEndDate,
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onSurface),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                WeatherContainer(
                  tripPoint: tripPoint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
