import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SOSOverlay extends StatefulWidget {
  const SOSOverlay({super.key});

  @override
  State<SOSOverlay> createState() => _SOSOverlayState();
}

class _SOSOverlayState extends State<SOSOverlay> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (_expanded) {
      return Positioned.fill(
        child: Container(
          color: const Color(0xFF111827),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 64)
                    .animate(onPlay: (c) => c.repeat())
                    .shake(duration: 1.seconds),
                const SizedBox(height: 24),
                const Text(
                  '深呼吸',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '冲动是魔鬼，冷静 60 秒',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 48),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 60, end: 0),
                  duration: const Duration(seconds: 60),
                  builder: (context, value, child) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.w200,
                      ),
                    );
                  },
                  onEnd: () {
                    setState(() => _expanded = false);
                  },
                ),
                const SizedBox(height: 48),
                TextButton(
                  onPressed: () => setState(() => _expanded = false),
                  child: const Text('我已冷静', style: TextStyle(color: Colors.white54)),
                )
              ],
            ),
          ),
        ).animate().fadeIn(),
      );
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 24,
      child: GestureDetector(
        onTap: () => setState(() => _expanded = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sos, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 1.seconds,
        ),
      ),
    );
  }
}