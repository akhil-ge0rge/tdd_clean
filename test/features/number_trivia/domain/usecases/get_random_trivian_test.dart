import 'package:clean_tdd_trivian/core/usecases/usecase.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_random_trivian.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomTrivian usecase;
  late NumberTriviaRepository repos;

  setUp(() {
    repos = MockNumberTriviaRepository();
    usecase = GetRandomTrivian(repository: repos);
  });
  final tTrivia = Trivia(text: "test", number: 1, found: true, type: "test");
  test('should get trivia for the random number', () async {
    when(() => repos.getTriviaRandom()).thenAnswer((_) async => Right(tTrivia));

    final result = await usecase(NoParams());

    expect(result, Right(tTrivia));

    verify(() => repos.getTriviaRandom()).called(1);
    verifyNoMoreInteractions(repos);
  });
}
