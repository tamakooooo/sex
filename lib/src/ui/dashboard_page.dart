import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

import 'package:sex/src/providers/record_provider.dart';
import 'package:sex/src/ui/calendar_section.dart';

class RecordDashboardPage extends ConsumerWidget {
  const RecordDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recordListProvider);
    final lastRecord = records.isNotEmpty ? records.first : null;
    final streakDays = records.isNotEmpty ? DateTime.now().difference(records.first).inDays : 0;
    final streakHours = records.isNotEmpty ? DateTime.now().difference(records.first).inHours % 24 : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, streakDays, streakHours),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                children: [
                  _buildStatsRow(records.length, lastRecord),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                    color: const Color(0x0D000000),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const CalendarSection(),
                  ),
                  const SizedBox(height: 24),
                  _buildActionRow(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int days, int hours) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFE6297), Color(0xFFF960DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
              BoxShadow(
                color: const Color(0x4CFE6297),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('保持节奏', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                '$days 天 $hours 时',
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int totalRecords, DateTime? lastRecord) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: '历史记录',
            value: '$totalRecords 次',
            icon: Iconify(
              Mdi.history,
              color: const Color(0xFFFE6297),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: '最近一次',
            value: lastRecord != null ? '${lastRecord.month}月${lastRecord.day}日' : '暂无',
            icon: Iconify(
              Mdi.calendar_check,
              color: const Color(0xFF981534),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required Widget icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _showRecordConfirmation(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF981534),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('导、撸、冲、扣', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: const Text('查看记录详情'),
        ),
      ],
    );
  }

  void _showRecordConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认记录'),
        content: const Text('是否立即记录当前破戒时间？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              ref.read(recordListProvider.notifier).addRecord(DateTime.now());
              Navigator.pop(context);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}
