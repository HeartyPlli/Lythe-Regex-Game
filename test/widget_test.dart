import 'package:flutter_test/flutter_test.dart';

import 'package:lythe/main.dart';

void main() {
  testWidgets('shows main menu and level selection', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('START GAME'), findsOneWidget);
    expect(find.text('LEADERBOARD'), findsOneWidget);

    await tester.tap(find.text('START GAME'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Loading...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    expect(find.text('CHOOSE YOUR LEVEL'), findsOneWidget);
    expect(find.text('EASY'), findsOneWidget);
    expect(find.text('EXTREME'), findsOneWidget);
  });
}
