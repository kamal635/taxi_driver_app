import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_driver_app/app/app.dart';
import 'package:taxi_driver_app/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view
        ..resetPhysicalSize()
        ..resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: TaxiDriverApp()));
    await tester.pumpAndSettle();

    // Don’t assert localized text. Assert the first screen exists.
    expect(find.byType(LoginPage), findsOneWidget);

    // Optional: ensure no uncaught exception happened during build.
    expect(tester.takeException(), isNull);
  });
}
