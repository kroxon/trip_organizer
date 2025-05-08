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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start date',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    )),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  tripPoint.formattedStartDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('End date',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  )),
                          SizedBox(height: 5),
                          if (tripPoint.endDate != null)
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  tripPoint.formattedEndDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
