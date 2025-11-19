import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_page.dart';
import 'sos_overlay.dart';

class SexHomePage extends ConsumerStatefulWidget {
  const SexHomePage({super.key});

  @override
  ConsumerState<SexHomePage> createState() => _SexHomePageState();
}

class _SexHomePageState extends ConsumerState<SexHomePage> {
  bool _isSOSActive = false;

  void _activateSOS() {
    setState(() => _isSOSActive = true);
  }

  void _deactivateSOS() {
    if (!mounted) return;
    setState(() => _isSOSActive = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('戒🦌'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.air),
            tooltip: 'SOS 呼吸练习',
            onPressed: _isSOSActive ? null : _activateSOS,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const DashboardTabContent(),
            if (_isSOSActive)
              Positioned.fill(
                child: SOSOverlay(onComplete: _deactivateSOS),
              ),
          ],
        ),
      ),
    );
  }
}
