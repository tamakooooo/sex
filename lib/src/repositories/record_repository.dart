import 'package:shared_preferences/shared_preferences.dart';

class RecordRepository {
  static const _recordsKey = 'record_timestamps';

  final SharedPreferences _preferences;

  const RecordRepository(this._preferences);

  /// 从 SharedPreferences 读取时间戳，并保证返回列表按时间降序。
  List<int> readTimestamps() {
    final raw = _preferences.getStringList(_recordsKey);
    if (raw == null) return [];
    final values = raw
        .map(int.tryParse)
        .whereType<int>()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    return values;
  }

  /// 保存时间戳列表，需要在写入前统一排序为最新优先。
  Future<void> saveTimestamps(List<int> timestamps) async {
    final normalized = timestamps.toList()
      ..sort((a, b) => b.compareTo(a));
    await _preferences.setStringList(
      _recordsKey,
      normalized.map((value) => value.toString()).toList(),
    );
  }

  /// 新增一条时间戳，并在 SharedPreferences 中持久化。
  Future<void> addTimestamp(int timestamp) async {
    final all = readTimestamps();
    all.add(timestamp);
    await saveTimestamps(all);
  }

  /// 删除指定下标的记录，越界则不做任何操作。
  Future<void> deleteTimestampAt(int index) async {
    final all = readTimestamps();
    if (index < 0 || index >= all.length) return;
    all.removeAt(index);
    await saveTimestamps(all);
  }
}
