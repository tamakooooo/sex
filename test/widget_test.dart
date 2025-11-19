import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sex/main.dart';
import 'package:sex/src/providers/record_provider.dart';

void main() {
  testWidgets('应用可以构建并展示导航', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await initializeDateFormatting('zh_CN', null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const SexApp(),
      ),
    );

    expect(find.textContaining('所选日期：'), findsWidgets);
    expect(find.text('导、撸、冲、扣'), findsOneWidget);
  });
}
