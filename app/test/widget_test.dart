import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hexablock/main.dart';

void main() {
  testWidgets('should_return_to_game_menu_when_leaving_lines', (tester) async {
    // Arrange
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MyApp());
    expect(find.text('HexaBlock'), findsOneWidget);
    for (final title in ['Hexa Lines', 'Hexa Sort', 'Hexa Merge']) {
      expect(find.text(title), findsOneWidget);
    }

    // Act
    final lines = find.text('Hexa Lines');
    await tester.ensureVisible(lines);
    await tester.tap(lines);
    await tester.pumpAndSettle();
    expect(find.text('Cómo jugar'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('HexaBlock'), findsOneWidget);
    expect(find.text('Hexa Lines'), findsOneWidget);
    expect(find.text('Cómo jugar'), findsNothing);
  });
}
