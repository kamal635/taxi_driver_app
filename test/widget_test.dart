import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_driver_app/app/app.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    final view = tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3.0;

    addTearDown(() {
      view
        ..resetPhysicalSize()
        ..resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: TaxiDriverApp()));
    await tester.pumpAndSettle();

    expect(find.text('Syrian Taxi'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
