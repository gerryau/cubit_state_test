import 'package:cubit_state_test/application/cubit/fact_cubit.dart';
import 'package:cubit_state_test/presentation/another_page.dart';
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
            child: CircularProgressIndicator(
              key: Key('progress-indicator'),
            ),
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
                ElevatedButton(
                  child: const Text('Go to Another Page?'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnotherPage()),
                    );
                  },
                )
              ],
            ),
          ),
          error: (e) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("📛 Couldn't fetch. Are you online?"),
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
