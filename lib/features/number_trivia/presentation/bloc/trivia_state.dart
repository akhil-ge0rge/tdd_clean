part of 'trivia_bloc.dart';

sealed class TriviaState extends Equatable {
  const TriviaState();

  @override
  List<Object> get props => [];
}

final class TriviaInitial extends TriviaState {
  const TriviaInitial();
}

final class TriviaLoading extends TriviaState {
  const TriviaLoading();
}

final class TriviaSucess extends TriviaState {
  final Trivia trivia;

  const TriviaSucess({required this.trivia});
}

final class TriviaFailure extends TriviaState {
  final String message;
  final int statusCode;

  const TriviaFailure({required this.message, required this.statusCode});
}
