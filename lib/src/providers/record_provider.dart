import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/record_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnsupportedError('sharedPreferencesProvider 必须在 main 中 override。');
});

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RecordRepository(prefs);
});

final recordProvider = NotifierProvider<RecordNotifier, List<DateTime>>(
  () => RecordNotifier(),
);

class RecordNotifier extends Notifier<List<DateTime>> {
  @override
  List<DateTime> build() {
    final repository = ref.read(recordRepositoryProvider);
    final timestamps = repository.readTimestamps();
    final records = timestamps
        .map((ms) => DateTime.fromMillisecondsSinceEpoch(ms))
        .toList();
    return records;
  }

  /// 最新的一条记录，state 默认保持降序。
  DateTime? get latestRecord => state.isNotEmpty ? state.first : null;

  /// 添加新记录并在持久层同步。
  Future<void> addRecord(DateTime time) async {
    final updated = [...state, time]
      ..sort((a, b) => b.compareTo(a));
    state = updated;
    await ref.read(recordRepositoryProvider).saveTimestamps(_encode(updated));
  }

  /// 删除指定索引的记录并在持久层同步。
  Future<void> deleteRecord(int index) async {
    if (index < 0 || index >= state.length) return;
    final updated = [...state]..removeAt(index);
    state = updated;
    await ref.read(recordRepositoryProvider).saveTimestamps(_encode(updated));
  }

  List<int> _encode(List<DateTime> entries) {
    return entries.map((dt) => dt.millisecondsSinceEpoch).toList();
  }
}
