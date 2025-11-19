import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sex/src/providers/record_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recordListProvider);
    
    // Calculate streak
    // Assuming records are sorted descending (latest first)
    // If not, we should sort them, but let's assume the provider does it or we do it here.
    // The provider in task-log said "ensure records descending".
    
    DateTime? lastRelapse;
    if (records.isNotEmpty) {
      lastRelapse = records.first.dateTime;
    }

    final now = DateTime.now();
    final startTime = lastRelapse ?? now; // If no relapse, start counting from now (0 days) or maybe we want to show "Clean since forever"? Let's stick to 0 for new users.
    
    // Actually, if no records, maybe the user has been clean for a long time? 
    // But usually you set a start date. For this simple app, let's assume 0 days if no records, 
    // or maybe we can treat "no records" as "start counting from today".
    // Let's just show the time since the last record.
    
    final duration = now.difference(startTime);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFE6297), Color(0xFFF960DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE6297).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '当前坚持',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$days',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '天',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$hours',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '小时',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  records.isEmpty ? '开始你的旅程' : '继续保持!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}