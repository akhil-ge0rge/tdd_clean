import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_trivia_with_number.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetTriviaWithNumber usecase;
  late NumberTriviaRepository repos;

  setUp(() {
    repos = MockNumberTriviaRepository();
    usecase = GetTriviaWithNumber(repository: repos);
  });
  final tNumber = 1;
  final tTrivia = Trivia(text: "test", number: 1, found: true, type: "test");
  test('should get trivia for the number from the repository', () async {
    when(
      () => repos.getTriviaWithNumber(number: any(named: "number")),
    ).thenAnswer((_) async => Right(tTrivia));

    final result = await usecase(TrivianParams(number: tNumber));

    expect(result, Right(tTrivia));

    verify(() => repos.getTriviaWithNumber(number: tNumber)).called(1);
    verifyNoMoreInteractions(repos);
  });
}
