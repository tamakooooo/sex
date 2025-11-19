// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:intl/intl.dart';

import '../providers/record_provider.dart';
import 'calendar_section.dart';

class DashboardTabContent extends ConsumerStatefulWidget {
  const DashboardTabContent({super.key});

  @override
  ConsumerState<DashboardTabContent> createState() => _DashboardTabContentState();
}

class _DashboardTabContentState extends ConsumerState<DashboardTabContent> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(recordProvider.notifier);
    final latest = notifier.latestRecord;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CalendarSection(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showRelapseSheet(context, notifier, latest),
              icon: const Iconify(
                Octicon.clock,
                color: Colors.white,
                size: 20,
              ),
              label: const Text('导、撸、冲、扣', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRelapseSheet(BuildContext context, RecordNotifier notifier, DateTime? latest) {
    final messenger = ScaffoldMessenger.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final navigator = Navigator.of(sheetContext);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('确认记录', style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text(
                '如实记录当前瞬间可以帮助你重新规划下一轮自律，计时器会从此刻重新开始。',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await notifier.addRecord(DateTime.now());
                  if (!navigator.mounted) return;
                  navigator.pop();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('已记录破戒时间，祝重整旗鼓')),
                  );
                },
                child: const Text('记录现在'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _pickCustomTime(sheetContext, notifier, latest),
                icon: const Icon(Icons.access_time),
                label: const Text('选择其他时间记录（精确到分钟）'),
              ),
              TextButton(
                onPressed: () {
                  if (navigator.mounted) {
                    navigator.pop();
                  }
                },
                child: const Text('取消'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickCustomTime(
    BuildContext context,
    RecordNotifier notifier,
    DateTime? latestRecord,
  ) async {
    final now = DateTime.now();
    final initial = latestRecord ?? now;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final pickerContext = context;
    final selectedDate = await showDatePicker(
      context: pickerContext,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (selectedDate == null) return;
    if (!mounted) return;

    final selectedTime = await showTimePicker(
      context: pickerContext,
      initialTime: TimeOfDay.fromDateTime(initial),
      initialEntryMode: TimePickerEntryMode.input,
      minuteLabelText: '分钟',
    );
    if (selectedTime == null) return;
    if (!mounted) return;

    final customTimestamp = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    await notifier.addRecord(customTimestamp);
    if (!mounted) return;
    if (navigator.canPop()) {
      navigator.pop();
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text('已记录 ${DateFormat('yyyy-MM-dd HH:mm').format(customTimestamp)}'),
      ),
    );
  }
}
