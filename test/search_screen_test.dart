import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2pfintech/Views/RootPage.dart';
import 'package:mockito/mockito.dart';
import 'package:m2pfintech/Views/SearchScreen.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MockRootCheckerPlus extends Mock implements RootCheckerPlus {}

void main() {

  group('SearchScreen Tests', () {
    testWidgets('Renders SearchScreen widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );


      expect(find.text('iTunes'), findsOneWidget);
      expect(find.text('Search for a variety of content'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Search term'), findsOneWidget);
    });

    testWidgets('Shows error toast if search term is empty', (WidgetTester tester) async {

      Fluttertoast.cancel();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );


      await tester.tap(find.text('Submit'));
      await tester.pump();


      expect(find.text('Please Enter the term'), findsOneWidget);
    });

    testWidgets('Adds and removes filters correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );


      expect(find.byType(ElevatedButton), findsNWidgets(8));


      await tester.tap(find.text('album'));
      await tester.pump();


      ElevatedButton albumButton = tester.widget(find.text('album').first);
      expect(albumButton.style!.backgroundColor!.resolve({}), Colors.green);


      await tester.tap(find.text('album'));
      await tester.pump();


      albumButton = tester.widget(find.text('album').first);
      expect(albumButton.style!.backgroundColor!.resolve({}), Colors.grey);
    });

    testWidgets('Detects root/jailbreak and redirects to RootPage', (WidgetTester tester) async {
      final mockRootChecker = MockRootCheckerPlus();



      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );


      await tester.pumpAndSettle();
      expect(find.byType(Rootpage), findsOneWidget);
    });
  });
}
