import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sex/src/providers/record_provider.dart';

class CalendarSection extends ConsumerStatefulWidget {
  const CalendarSection({super.key});

  @override
  ConsumerState<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends ConsumerState<CalendarSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(recordListProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            locale: 'zh_CN',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return records.where((r) => isSameDay(r.dateTime, day)).toList();
            },
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                color: Color(0xFFFE6297),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(color: Color(0xFF1F2937)),
              weekendTextStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              outsideTextStyle: const TextStyle(color: Color(0xFFE5E7EB)),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF6B7280)),
              rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final text = const ['一', '二', '三', '四', '五', '六', '日'][day.weekday - 1];
                return Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedDay != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedDay!.month}月${_selectedDay!.day}日',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const Spacer(),
                  if (records.any((r) => isSameDay(r.dateTime, _selectedDay)))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE6297).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '已破戒',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFE6297),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '未破戒',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}