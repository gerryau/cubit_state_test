import 'package:cubit_state_test/application/cubit/fact_cubit.dart';
import 'package:cubit_state_test/domain/fact.dart';
import 'package:cubit_state_test/infrastructure/fact_repository.dart';
import 'package:cubit_state_test/presentation/random_fact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFactRepository extends Mock implements FactRepository {}

void main() {
  late MockFactRepository mockFactRepository;

  setUp(() {
    mockFactRepository = MockFactRepository();
  });

  const fact = Fact(text: 'This is a random fact');

  void arrangeFactRepositoryReturn1Fact() {
    when(() => mockFactRepository.fetchFact()).thenAnswer(
      (_) async => fact,
    );
  }

  void arrangeFactRepositoryReturn1FactAfter2SecondWait() {
    //simulates network
    when(() => mockFactRepository.fetchFact()).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        return fact;
      },
    );
  }

  void arrangeFactRepositoryThrowError() {
    when(() => mockFactRepository.fetchFact())
        .thenAnswer((_) => throw (NetworkError()));
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 24.0),
          bodyText2: TextStyle(fontSize: 22.0),
          button: TextStyle(fontSize: 22.0),
        ), // and so on for every text style
      ),
      home: BlocProvider(
        create: (context) => FactCubit(mockFactRepository),
        child: const RandomFactPage(),
      ),
    );
  }

  testWidgets(
    "title is displayed", //Random Fact
    (WidgetTester tester) async {
      arrangeFactRepositoryReturn1Fact();
      await tester.pumpWidget(
        createWidgetUnderTest(),
      );
      expect(find.text('Random Fact'), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed when button tapped and waiting for fact",
    (WidgetTester tester) async {
      //arrangeFactRepositoryReturn1FactAfter2SecondWait();
      arrangeFactRepositoryReturn1FactAfter2SecondWait();
      await tester.pumpWidget(createWidgetUnderTest());
      //Force rebuild of widget to give enough time for scaffold to load
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      verify(() => mockFactRepository.fetchFact()).called(1);

      //Wait until no more rebuilds are happening
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "fact displayed when fact loaded successfully",
    (WidgetTester tester) async {
      arrangeFactRepositoryReturn1Fact();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get random fact'));
      await tester.pumpAndSettle();
      expect(find.text('👍️ ${fact.text}'), findsOneWidget);
    },
  );

  testWidgets(
    "error displayed when fact loaded unsuccessfully",
    (WidgetTester tester) async {
      arrangeFactRepositoryThrowError();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get random fact'));
      await tester.pumpAndSettle();

      expect(
        find.text('📛 Couldn\'t fetch. Are you online?'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "loading indicator is displayed when an additional fact is requested",
    (WidgetTester tester) async {
      //arrangeFactRepositoryReturn1FactAfter2SecondWait();
      arrangeFactRepositoryReturn1FactAfter2SecondWait();
      await tester.pumpWidget(createWidgetUnderTest());
      //Force rebuild of widget to give enough time for scaffold to load
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get random fact'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Another fact'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );

      verify(() => mockFactRepository.fetchFact()).called(2);

      //Wait until no more rebuilds are happening
      await tester.pumpAndSettle();
    },
  );
}
