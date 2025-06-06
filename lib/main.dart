import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/landing/presentation/screens/landing_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Load the .env file
  runApp(const ProviderScope(child: HeavyFreightApp()));
}

class HeavyFreightApp extends StatelessWidget {
  const HeavyFreightApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HeavyFreight',
      theme: AppTheme.theme,
      home: const LandingScreen(),
    );
  }
}
