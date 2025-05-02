import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_organizer/screens/travels.dart';
import 'package:trip_organizer/providers/theme_provider.dart';
import 'package:trip_organizer/theme/app_theme.dart';
import 'package:trip_organizer/theme/color_schemes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const appTitle = 'Trip Organizer';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: appTitle,
      themeMode: themeMode,
      theme: AppTheme.createTheme(lightColorScheme),
      darkTheme: AppTheme.createTheme(darkColorScheme),
      home: const TravelsScreen(),
    );
  }
}
