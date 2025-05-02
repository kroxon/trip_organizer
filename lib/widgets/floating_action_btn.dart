import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_organizer/providers/theme_provider.dart'; 

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final themeMode = ref.watch(themeProvider);
        final isDarkMode = themeMode == ThemeMode.dark;
        
        return FloatingActionButton.extended(
          onPressed: onPressed,
          label: Text(
            'New Travel',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isDarkMode
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
          ),
          icon: Icon(
            Icons.luggage,
            size: 24,
            color: isDarkMode
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: isDarkMode
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isDarkMode
                ? BorderSide.none
                : BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
          ),
        );
      },
    );
  }
}