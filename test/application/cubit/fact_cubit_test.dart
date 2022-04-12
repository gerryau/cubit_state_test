import 'package:bloc_test/bloc_test.dart';
import 'package:cubit_state_test/application/cubit/fact_cubit.dart';
import 'package:cubit_state_test/domain/fact.dart';
import 'package:cubit_state_test/infrastructure/fact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFactRepository extends Mock implements FactRepository {}

void main() {
  late MockFactRepository mockFactRepository;

  setUp(() {
    mockFactRepository = MockFactRepository();
  });

//Note: groups are for organizing individual tests as well as for creating a context in which you can share a common setUp and tearDown across all of the individual tests.

  group(
    'GetFact',
    () {
      const fact = Fact(text: 'This is a random fact');
      test(
        "initial state is empty",
        () async {
          expect(
            FactCubit(mockFactRepository).state,
            const FactState.initial(),
          );
        },
      );

      blocTest(
        'emits [FactCubit.loading, .loaded] when successful',
        build: () {
          when(() => mockFactRepository.fetchFact())
              .thenAnswer((_) async => fact);
          return FactCubit(mockFactRepository);
        },
        act: (FactCubit cubit) => cubit.getFact(),
        expect: () => [
          const FactState.loading(),
          const FactState.loaded(fact),
        ],
        verify: (_) {
          verify(() => mockFactRepository.fetchFact()).called(1);
        },
      );

      blocTest('emits [FactCubit.loading, FactCubit.error] when unsuccessful',
          build: () {
            when(() => mockFactRepository.fetchFact())
                .thenThrow(NetworkError().toString());
            return FactCubit(mockFactRepository);
          },
          act: (FactCubit cubit) => cubit.getFact(),
          expect: () => [
                const FactState.loading(),
                const FactState.error("Instance of 'NetworkError'"),
              ],
          verify: (_) {
            verify(() => mockFactRepository.fetchFact()).called(1);
          });
    },
  );
}
