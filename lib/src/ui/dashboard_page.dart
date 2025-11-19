import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sex/src/providers/record_provider.dart';
import 'package:sex/src/ui/calendar_section.dart';
import 'package:sex/src/ui/streak_card.dart';

class RecordDashboardPage extends ConsumerWidget {
  const RecordDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('你好，自律者',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 12),
              const Text('今天也不要忘了打卡！', style: TextStyle(color: Color(0xFF475569))),
              const SizedBox(height: 24),
              const StreakCard(),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const CalendarSection(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _showAddRecordDialog(context, ref),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: const Color(0xFFFE6297),
                ),
                child: const Text(
                  '导、撸、冲、扣',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddRecordDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('记录破戒', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(recordListProvider.notifier).addRecord(DateTime.now());
                Navigator.pop(context);
              },
              child: const Text('就是现在'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                final modalContext = context;
                final navigator = Navigator.of(modalContext);
                final date = await showDatePicker(
                  context: modalContext,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date == null || !modalContext.mounted) return;
                final time = await showTimePicker(
                  context: modalContext,
                  initialTime: TimeOfDay.now(),
                );
                if (time == null || !modalContext.mounted) return;
                final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                ref.read(recordListProvider.notifier).addRecord(dt);
                if (navigator.mounted) {
                  navigator.pop();
                }
              },
              child: const Text('选择其他时间（精确到分钟）'),
            ),
          ],
        ),
      ),
    );
  }
}
