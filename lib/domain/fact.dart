import 'package:equatable/equatable.dart';

class Fact extends Equatable {
  final String text;

  const Fact({
    required this.text,
  });

  @override
  List<Object> get props => [text];
}
