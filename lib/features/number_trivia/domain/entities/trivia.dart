import 'package:equatable/equatable.dart';

class Trivia extends Equatable {
  final String text;
  final int number;
  final bool found;
  final String type;

  const Trivia({
    required this.text,
    required this.number,
    required this.found,
    required this.type,
  });
  @override
  List<Object> get props => [text, number, found, type];
}
