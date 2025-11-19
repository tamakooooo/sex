import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sex/src/ui/home_page.dart';

void main() {
  initializeDateFormatting('zh_CN', null).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sex',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFE6297),
          secondary: Color(0xFFF960DB),
          tertiary: Color(0xFF981534),
          error: Color(0xFF762A2A),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const SexHomePage(),
    );
  }
}