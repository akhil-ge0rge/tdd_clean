import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/core/usecases/usecase.dart';
import 'package:clean_tdd_trivian/core/utils/input_converter.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_random_trivian.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_trivia_with_number.dart';
import 'package:clean_tdd_trivian/features/number_trivia/presentation/bloc/trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

const String serverFailureMessage = "Server Failure";
const String cacheFailureMessage = "Cache Failure";
const String invalidStringFailureMessage = "Cache Failure";

class MockGetTriviaWithNumber extends Mock implements GetTriviaWithNumber {}

class MockGetRandomTrivian extends Mock implements GetRandomTrivian {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late GetTriviaWithNumber getTriviaWithNumber;
  late GetRandomTrivian getRandomTrivian;
  late InputConverter inputConverter;
  late TriviaBloc bloc;

  setUp(() {
    getRandomTrivian = MockGetRandomTrivian();
    getTriviaWithNumber = MockGetTriviaWithNumber();
    inputConverter = MockInputConverter();
    bloc = TriviaBloc(
      getTriviaForNumber: getTriviaWithNumber,
      getRandomTrivian: getRandomTrivian,
      inputConverter: inputConverter,
    );
    registerFallbackValue(TrivianParams(number: 1));
    registerFallbackValue(NoParams());
  });

  tearDown(() => bloc.close());
  test('return TriviaInitial as InititalState', () {
    expect(bloc.state, equals(TriviaInitial()));
  });

  group('GetTriviaForNumberEvent', () {
    final tNumberString = '1';
    final tNumber = 1;

    final tTriviaModel = TriviaModel(
      text: 'text',
      number: 1,
      found: true,
      type: "type",
    );
    void setUpMockInputConverterStringSucess() {
      when(
        () => inputConverter.convertStringToInteger(any()),
      ).thenReturn(Right(tNumber));
    }

    void verifyOnInputConvertorAndGetTrivaiWithNumberUseCase() {
      (_) {
        verify(
          () => inputConverter.convertStringToInteger(tNumberString),
        ).called(1);
        verify(
          () => getTriviaWithNumber(TrivianParams(number: tNumber)),
        ).called(1);
      };
    }

    blocTest(
      'should emit [TriviaLoading,TriviaSucess] when GetTriviaForNumberEvent is sucess',
      build: () {
        setUpMockInputConverterStringSucess();
        when(
          () => getTriviaWithNumber(any()),
        ).thenAnswer((invocation) async => Right(tTriviaModel));
        return bloc;
      },

      act: (bloc) => bloc.add(GetTriviaForNumber(number: tNumberString)),

      expect: () => [TriviaLoading(), TriviaSucess(trivia: tTriviaModel)],

      verify: (_) {
        verifyOnInputConvertorAndGetTrivaiWithNumberUseCase();
      },
    );

    blocTest(
      'should emit [TriviaError] when GetTriviaForNumberEvent number is not a number',
      build: () {
        when(() => inputConverter.convertStringToInteger(any())).thenReturn(
          Left(
            InvalidInputFailure(
              message: invalidStringFailureMessage,
              statusCode: 404,
            ),
          ),
        );
        return bloc;
      },

      act: (bloc) => bloc.add(GetTriviaForNumber(number: "abc")),

      expect:
          () => [
            TriviaFailure(
              message: invalidStringFailureMessage,
              statusCode: 404,
            ),
          ],

      verify: (_) {
        verify(() => inputConverter.convertStringToInteger("abc")).called(1);
      },
    );

    blocTest(
      'should emit [TriviaLoading,TriviaError] when GetTriviaForNumberEvent is failure',
      build: () {
        setUpMockInputConverterStringSucess();
        when(() => getTriviaWithNumber(any())).thenAnswer(
          (invocation) async => Left(
            ServerFailure(message: serverFailureMessage, statusCode: 404),
          ),
        );
        return bloc;
      },

      act: (bloc) => bloc.add(GetTriviaForNumber(number: tNumberString)),

      expect:
          () => [
            TriviaLoading(),
            TriviaFailure(message: serverFailureMessage, statusCode: 404),
          ],
      verify: (_) {
        verifyOnInputConvertorAndGetTrivaiWithNumberUseCase();
      },
    );
  });

  group('getTriviaForRandom', () {
    final tTriviaModel = TriviaModel(
      text: 'text',
      number: 1,
      found: true,
      type: "type",
    );

    blocTest(
      'should emit [TriviaLoading,TriviaSucess] when GetTrivianRandomEvnet is sucess',
      build: () {
        when(
          () => getRandomTrivian(any()),
        ).thenAnswer((invocation) async => Right(tTriviaModel));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandom()),

      expect: () => [TriviaLoading(), TriviaSucess(trivia: tTriviaModel)],
      verify: (_) {
        verify(() => getRandomTrivian(NoParams())).called(1);
      },
    );

    blocTest(
      'should emit [TriviaFailure] when GetTrivianRandomEvnet is unscucess',
      build: () {
        when(() => getRandomTrivian(any())).thenAnswer(
          (invocation) async => Left(
            ServerFailure(message: serverFailureMessage, statusCode: 404),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandom()),
      expect:
          () => [
            TriviaLoading(),
            TriviaFailure(message: serverFailureMessage, statusCode: 404),
          ],
      verify: (_) {
        verify(() => getRandomTrivian(NoParams())).called(1);
      },
    );
  });
}
