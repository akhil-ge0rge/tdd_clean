import 'package:clean_tdd_trivian/core/usecases/usecase.dart';
import 'package:clean_tdd_trivian/core/utils/input_converter.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_random_trivian.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_trivia_with_number.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:equatable/equatable.dart';

part 'trivia_event.dart';
part 'trivia_state.dart';

class TriviaBloc extends Bloc<TriviaEvent, TriviaState> {
  final GetTriviaWithNumber _getTriviaForNumber;
  final GetRandomTrivian _getRandomTrivian;
  final InputConverter _inputConverter;
  TriviaBloc({
    required GetTriviaWithNumber getTriviaForNumber,
    required GetRandomTrivian getRandomTrivian,
    required InputConverter inputConverter,
  }) : _getTriviaForNumber = getTriviaForNumber,
       _getRandomTrivian = getRandomTrivian,
       _inputConverter = inputConverter,
       super(TriviaInitial()) {
    on<GetTriviaForNumber>(_getTriviaForNumberHandler);
    on<GetTriviaForRandom>(_getTriviaForRandomHandler);
  }

  Future<void> _getTriviaForNumberHandler(
    GetTriviaForNumber event,
    Emitter<TriviaState> emit,
  ) async {
    final integer = _inputConverter.convertStringToInteger(event.number);

    integer.fold(
      (l) => emit(TriviaFailure(message: l.message, statusCode: l.statusCode)),
      (r) async {
        emit(TriviaLoading());
        final res = await _getTriviaForNumber(TrivianParams(number: r));

        res.fold(
          (l) =>
              emit(TriviaFailure(message: l.message, statusCode: l.statusCode)),
          (r) => emit(TriviaSucess(trivia: r)),
        );
      },
    );
  }

  Future<void> _getTriviaForRandomHandler(
    GetTriviaForRandom event,
    Emitter<TriviaState> emit,
  ) async {
    emit(TriviaLoading());
    final res = await _getRandomTrivian(NoParams());
    res.fold(
      (l) => emit(TriviaFailure(message: l.message, statusCode: l.statusCode)),
      (r) => emit(TriviaSucess(trivia: r)),
    );
  }
}
