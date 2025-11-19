import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/providers/record_provider.dart';
import 'src/ui/home_page.dart';

const _appTitle = '戒🦌';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('zh_CN', null);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const SexApp(),
    ),
  );
}

class SexApp extends StatelessWidget {
  const SexApp({super.key});

  static const _primary = Color(0xFFFE6297);
  static const _secondary = Color(0xFFF960DB);
  static const _accent = Color(0xFF981534);
  static const _warn = Color(0xFF762A2A);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
      error: _warn,
      onError: Colors.white,
      tertiary: _accent,
      onTertiary: Colors.white,
      primaryContainer: _primary,
      onPrimaryContainer: Colors.white,
      secondaryContainer: _secondary,
      onSecondaryContainer: Colors.white,
    );

    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const SexHomePage(),
    );
  }
}
