import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/record_provider.dart';

class CalendarSection extends ConsumerStatefulWidget {
  const CalendarSection({super.key});

  @override
  ConsumerState<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends ConsumerState<CalendarSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get _today => DateTime.now();

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(recordProvider);
    final grouped = _groupRecords(records);
    final selectedRecords = _eventsForDay(_selectedDay, grouped);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: TableCalendar<DateTime>(
            firstDay: _today.subtract(const Duration(days: 365)),
            lastDay: _today.add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            locale: 'zh_CN',
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) => _isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
            calendarStyle: const CalendarStyle(outsideDaysVisible: true),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) => _dayBuilder(context, day, grouped),
              todayBuilder: (context, day, focusedDay) => _dayBuilder(context, day, grouped, isToday: true),
              selectedBuilder: (context, day, focusedDay) =>
                  _dayBuilder(context, day, grouped, isSelected: true),
              dowBuilder: (context, day) => _dowBuilder(context, day),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '所选日期：${DateFormat('yyyy-MM-dd').format(_selectedDay)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: selectedRecords.isEmpty
              ? const Center(child: Text('该日暂无破戒记录。'))
              : ListView.separated(
                  itemCount: selectedRecords.length,
                  separatorBuilder: (context, index) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final record = selectedRecords[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(DateFormat('HH:mm:ss').format(record)),
                      subtitle: Text('记录 #${index + 1}'),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _dayBuilder(BuildContext context, DateTime day, Map<DateTime, List<DateTime>> grouped,
      {bool isSelected = false, bool isToday = false}) {
    final normalized = _normalize(day);
    final hasRecord = grouped.containsKey(normalized);
    final normalizedToday = _normalize(_today);
    final isPast = normalized.isBefore(normalizedToday);
    final isCleanPast = isPast && !hasRecord;
    final bgColor = hasRecord
        ? Colors.red.shade50
        : isCleanPast
            ? Colors.green.shade50
            : Colors.transparent;
    final textColor = hasRecord
        ? Colors.red.shade700
        : isCleanPast
            ? Colors.green.shade700
            : Colors.black87;
    final borderColor = isSelected ? Colors.indigo.shade700 : Colors.transparent;
    final todayBorder = isToday ? Colors.indigo.shade200 : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor == Colors.transparent ? todayBorder : borderColor,
          width: borderColor == Colors.transparent ? 1 : 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }

  Map<DateTime, List<DateTime>> _groupRecords(List<DateTime> records) {
    final map = <DateTime, List<DateTime>>{};
    for (final record in records) {
      final key = _normalize(record);
      map.putIfAbsent(key, () => []).add(record);
    }
    return map;
  }

  List<DateTime> _eventsForDay(DateTime day, Map<DateTime, List<DateTime>> grouped) {
    final key = _normalize(day);
    final events = grouped[key];
    if (events == null) return [];
    final sorted = [...events]..sort((a, b) => b.compareTo(a));
    return sorted;
  }

  DateTime _normalize(DateTime candidate) => DateTime(candidate.year, candidate.month, candidate.day);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _dowBuilder(BuildContext context, DateTime day) {
    const mapping = {
      DateTime.monday: '一',
      DateTime.tuesday: '二',
      DateTime.wednesday: '三',
      DateTime.thursday: '四',
      DateTime.friday: '五',
      DateTime.saturday: '六',
      DateTime.sunday: '日',
    };
    final label = mapping[day.weekday] ?? '';
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
