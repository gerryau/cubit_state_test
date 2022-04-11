import 'package:cubit_state_test/application/cubit/fact_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/cubit/fact_cubit.dart';

class RandomFactPage extends StatelessWidget {
  const RandomFactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Fact'),
      ),
      body: BlocBuilder<FactCubit, FactState>(builder: (context, state) {
        return state.when(
          initial: () => Center(
            child: ElevatedButton(
              child: const Text('Get random fact'),
              onPressed: () => context.read<FactCubit>().getFact(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          loaded: (fact) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("👍️ ${fact.text}"),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Another fact'),
                  onPressed: () => context.read<FactCubit>().getFact(),
                ),
              ],
            ),
          ),
          error: (e) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("📛 $e"),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Try again'),
                  onPressed: () => context.read<FactCubit>().getFact(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// void submitCityName(BuildContext context, String cityName) {
//   final weatherBloc = context.bloc<WeatherBloc>();
//   weatherBloc.add(GetWeather(cityName));
// }
