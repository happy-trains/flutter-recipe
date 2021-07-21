import 'package:flutter_test/flutter_test.dart';

import 'package:recipe/widgets/app.dart';

void main() {
  testWidgets('HomePage shows the app name in AppBar',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that Homepage has correct title.
    expect(find.text('Recipe'), findsOneWidget);
  });
}
