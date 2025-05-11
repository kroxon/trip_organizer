import 'package:flutter/material.dart';
import 'package:open_weather_client/enums/languages.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_client/open_weather.dart';

class WeatherContainer extends StatefulWidget {
  const WeatherContainer({
    super.key,
    required this.tripPoint,
  });

  final TripPoint tripPoint;

  @override
  State<WeatherContainer> createState() => _WeatherContainerState();
}

class _WeatherContainerState extends State<WeatherContainer> {
  WeatherData? weatherData;
  bool isLoading = true;
  String? error;
  late OpenWeather _openWeather;
  late TripPoint tripPoint;
  DateTime? targetDate;

  @override
  void initState() {
    super.initState();
    tripPoint = widget.tripPoint;
    _openWeather = OpenWeather(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      isLoading = true;
      error = null;
      weatherData = null;
    });

    final now = DateTime.now();
    final startDate = tripPoint.startDate;

    targetDate = startDate.isBefore(DateTime(now.year, now.month, now.day))
        ? now
        : startDate;

    if (targetDate!.difference(now).inDays > 5) {
      setState(() {
        error =
            'Weather forecast available in ${(5 - targetDate!.difference(now).inDays) * (-1)} days.';
        isLoading = false;
      });
      return;
    }

    final dayIndex = targetDate!.difference(now).inDays;

    try {
      final data = await _openWeather
          .fiveDaysWeatherForecastByLocation(
              latitude: tripPoint.tripPointLocation.latitude,
              longitude: tripPoint.tripPointLocation.longitude,
              weatherUnits: WeatherUnits.METRIC,
              language: Languages.ENGLISH)
          .catchError((err) {
        setState(() {
          error = 'Failed to load weather: $err';
          isLoading = false;
        });
        throw err;
      });

      setState(() {
        weatherData = data.forecastData[dayIndex];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
        print('Error: $error');
      });
    }
  }

  String _getDisplayDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      width: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
          width: 1,
        ),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    error!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${weatherData!.details.first.icon}@2x.png',
                      width: 64,
                      height: 64,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_sunny_outlined,
                        size: 64,
                      ),
                    ),
                    Text(
                      '${weatherData!.temperature.currentTemperature.round()}°C',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDisplayDate(targetDate!),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
    );
  }
}
