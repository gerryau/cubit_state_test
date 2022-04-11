part of 'fact_cubit.dart';

@freezed
class FactState with _$FactState {
  const factory FactState.initial() = _Initial;
  const factory FactState.loading() = _Loading;
  const factory FactState.loaded(Fact fact) = _Loaded;
  const factory FactState.error(String message) = _Error;
}
