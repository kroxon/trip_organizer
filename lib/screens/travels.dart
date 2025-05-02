import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_organizer/providers/theme_provider.dart';
import 'package:trip_organizer/widgets/floating_action_btn.dart'; 

class TravelsScreen extends ConsumerStatefulWidget {
  const TravelsScreen({super.key});

  @override
  ConsumerState<TravelsScreen> createState() {
    return _TravelsScreenState();
  }
}

class _TravelsScreenState extends ConsumerState<TravelsScreen> {


  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Travels'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  isDarkMode ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Travels Screen',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Floating Action Button Pressed!',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
          );
        },
      ),
    );
  }
}
