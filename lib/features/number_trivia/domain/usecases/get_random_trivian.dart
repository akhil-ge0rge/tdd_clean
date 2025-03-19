import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/core/usecases/usecase.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomTrivian implements UseCase<Trivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomTrivian({required this.repository});
  @override
  Future<Either<Failure, Trivia>> call(NoParams params) async =>
      repository.getTriviaRandom();
}
