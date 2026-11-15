import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests_gabriel/widgets/greeting.dart';

void main() {
  group('GreetingCard Widget Tests', () {
    testWidgets('Render check: displays greeting with user name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GreetingCard(userName: 'Alice'),
          ),
        ),
      );

      // Verify 'Hello, Alice!' appears once on screen
      expect(find.text('Hello, Alice!'), findsOneWidget);
    });

    testWidgets('Initial state check: displays Likes: 0 initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GreetingCard(userName: 'Alice'),
          ),
        ),
      );

      // Verify initial likes count is 0
      expect(find.text('Likes: 0'), findsOneWidget);
      expect(find.byKey(const Key('likes_text_key')), findsOneWidget);
    });

    testWidgets('Interaction check: tapping Like button increments likes to 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GreetingCard(userName: 'Alice'),
          ),
        ),
      );

      // Find the button using the key defined in GreetingCard
      final likeButton = find.byKey(const Key('like_button_key'));

      // Tap the button and trigger a frame rebuild
      await tester.tap(likeButton);
      await tester.pump();

      // Verify the text updated from 'Likes: 0' to 'Likes: 1'
      expect(find.text('Likes: 0'), findsNothing);
      expect(find.text('Likes: 1'), findsOneWidget);
    });
  });
}
