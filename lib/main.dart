import 'package:cubit_state_test/application/cubit/fact_cubit.dart';
import 'package:cubit_state_test/infrastructure/fact_repository.dart';
import 'package:cubit_state_test/presentation/random_fact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        create: (context) => FactCubit(FakeFactRepository()),
        child: const RandomFactPage(),
      ),
    );
  }
}
