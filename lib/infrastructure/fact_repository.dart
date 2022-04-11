import 'dart:math';

import '../domain/fact.dart';

abstract class FactRepository {
  // Throws [NetworkException].
  Future<Fact> fetchFact();
}

class FakeFactRepository implements FactRepository {
  @override
  Future<Fact> fetchFact() {
    // Simulate network delay
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        final random = Random();

        // Simulate some network exception
        if (random.nextBool()) {
          throw NetworkException();
        }

        // Return "fetched" fact
        return const Fact(
          text: "This is a random fact",
        );
      },
    );
  }
}

class NetworkException implements Exception {}
