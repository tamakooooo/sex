import 'dart:async';

import 'package:flutter/material.dart';

class SOSOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const SOSOverlay({super.key, required this.onComplete});

  @override
  State<SOSOverlay> createState() => _SOSOverlayState();
}

class _SOSOverlayState extends State<SOSOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  Timer? _countdownTimer;
  int _remaining = 60;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remaining <= 1) {
        timer.cancel();
        setState(() => _remaining = 0);
        widget.onComplete();
        return;
      }
      setState(() => _remaining -= 1);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlayColor = Colors.indigo.shade900.withValues(alpha: 242);
    final shadowColor = Colors.indigo.shade300.withValues(alpha: 153);
    final scheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: overlayColor),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          scheme.secondary,
                          scheme.primaryContainer,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$_remaining s',
                        style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('深呼吸，专注当下', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                const Text(
                  '60秒倒计时完成之前无法退出，等待脑海冷静下来。',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
