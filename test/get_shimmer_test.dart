import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_shimmer/get_shimmer.dart';

void main() {
  testWidgets('Shimmer widget builds (disabled animation)',
      (WidgetTester tester) async {
    final gradient =
        LinearGradient(colors: [Colors.grey, Colors.white, Colors.grey]);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: GetShimmer(
            child: Container(width: 100, height: 20),
            gradient: gradient,
            enabled: false, // disable animation during test
          ),
        ),
      ),
    );
  });
}
