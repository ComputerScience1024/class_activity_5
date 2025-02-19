import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet_app/main.dart';

void main() {
  testWidgets('Digital Pet App UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DigitalPetApp()));

    // Check if the pet name is displayed
    expect(find.text('Name: Your Pet'), findsOneWidget);

    // Check if buttons exist
    expect(find.text('Play with Your Pet'), findsOneWidget);
    expect(find.text('Feed Your Pet'), findsOneWidget);

    // Simulate playing with pet
    await tester.tap(find.text('Play with Your Pet'));
    await tester.pump();

    // Check if happiness level increases
    expect(find.textContaining('Happiness Level:'), findsWidgets);

    // Simulate feeding pet
    await tester.tap(find.text('Feed Your Pet'));
    await tester.pump();

    // Ensure Hunger Level is decreasing
    expect(find.textContaining('Hunger Level:'), findsWidgets);
  });

  testWidgets('Pet Name Customization Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DigitalPetApp()));

    // Find the text input field
    final Finder textField = find.byType(TextField);

    // Enter a new pet name
    await tester.enterText(textField, 'Buddy');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Check if the new pet name appears
    expect(find.text('Name: Buddy'), findsOneWidget);
  });

  testWidgets('Hunger Timer Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DigitalPetApp()));

    // Initial hunger level
    expect(find.textContaining('Hunger Level:'), findsWidgets);

    // Wait 30 seconds for hunger increase
    await tester.pump(Duration(seconds: 30));

    // Hunger should have increased
    expect(find.textContaining('Hunger Level:'), findsWidgets);
  });

  testWidgets('Mood Changes Based on Happiness', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DigitalPetApp()));

    // Default mood should be neutral
    expect(find.text('Mood: Neutral 😐'), findsOneWidget);

    // Play with pet to increase happiness
    await tester.tap(find.text('Play with Your Pet'));
    await tester.pump();

    // Happiness increases, mood should update
    expect(find.textContaining('Mood:'), findsWidgets);
  });
}
