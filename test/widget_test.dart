// CareSync Widget Test
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:caresync/main.dart';

void main() {
  testWidgets('CareSync app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: CareSyncApp()));

    // Verify that the app builds successfully
    expect(find.byType(CareSyncApp), findsOneWidget);

    // Pump frames to allow timers to complete
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
