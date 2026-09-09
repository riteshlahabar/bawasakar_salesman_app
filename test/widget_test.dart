import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:salesman_app/app/app.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('Salesman app moves from splash to login screen', (tester) async {
    await tester.pumpWidget(const SalesmanApp());

    expect(find.text('Bawaskar Sales'), findsOneWidget);
    expect(find.text('Salesman ERP'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email here'), findsOneWidget);
  });

  testWidgets('Salesman can open dealers tab without GetX errors', (
    tester,
  ) async {
    await tester.pumpWidget(const SalesmanApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log In').last);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Assigned Dealers'), findsWidgets);
    expect(find.text('Shree Agro Center'), findsOneWidget);
  });
}
