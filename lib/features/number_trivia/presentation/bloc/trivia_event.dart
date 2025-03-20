part of 'trivia_bloc.dart';

sealed class TriviaEvent extends Equatable {
  const TriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForRandom extends TriviaEvent {}

class GetTriviaForNumber extends TriviaEvent {
  final String number;

  const GetTriviaForNumber({required this.number});
}
