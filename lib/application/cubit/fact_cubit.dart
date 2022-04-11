import 'package:bloc/bloc.dart';
import 'package:cubit_state_test/domain/fact.dart';
import 'package:cubit_state_test/infrastructure/fact_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fact_state.dart';
part 'fact_cubit.freezed.dart';

class FactCubit extends Cubit<FactState> {
  // Add a constructor that accepts a [FactRepository]
  final FactRepository _factRepository;

  FactCubit(this._factRepository) : super(const FactState.initial());

  // Add a getter for the fact
  Future<void> getFact() async {
    emit(const FactState.loading());
    try {
      final fact = await _factRepository.fetchFact();
      emit(FactState.loaded(fact));
    } catch (e) {
      emit(FactState.error(e.toString()));
    }
  }
}
