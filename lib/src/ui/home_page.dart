import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sex/src/ui/dashboard_page.dart';
import 'package:sex/src/ui/sos_overlay.dart';

class SexHomePage extends ConsumerWidget {
  const SexHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Stack(
        children: [
          RecordDashboardPage(),
          SOSOverlay(),
        ],
      ),
    );
  }
}