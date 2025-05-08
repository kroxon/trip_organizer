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

    if (startDate.difference(now).inDays > 5) {
      setState(() {
        error =
            'Weather forecast not available yet.\nCheck again ${5 - startDate.difference(now).inDays} days before the trip.';
        isLoading = false;
      });
      return;
    }

    final targetDate = startDate.isBefore(now) ? now : startDate;
    final dayIndex = targetDate.difference(now).inDays;

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
      });
    }
  }

  String _getDisplayDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
      color: Colors.white,
      //       gradient: const LinearGradient(
      //   colors: [
      //   Color.fromARGB(255, 209, 228, 240), // jasny niebieski
      //   Color.fromARGB(255, 210, 216, 89),
      //   ],
      //   begin: Alignment.topLeft,
      //   end: Alignment.bottomRight,
      // ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color.fromARGB(255, 129, 88, 88),
        width: 1,
      ),
      ),
      child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : error != null
          ? Center(child: Text(error!))
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
            const SizedBox(height: 8),
            Text(
              '${weatherData!.temperature.currentTemperature.round()}°C',
              style:
                Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _getDisplayDate(tripPoint.startDate),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                  Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ),
            ],
          ),
    );
  }
}
