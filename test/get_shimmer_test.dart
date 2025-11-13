import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_shimmer/get_shimmer.dart';

void main() {
  testWidgets('GetShimmer.fromColors builds (disabled animation)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: GetShimmer.fromColors(
            child: Container(width: 100, height: 20),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: false, // disable animation during test
          ),
        ),
      ),
    );

    // The GetShimmer exists in the widget tree
    expect(find.byType(GetShimmer), findsOneWidget);
    // The inner Container is present
    expect(find.byType(Container), findsOneWidget);
  });
}
