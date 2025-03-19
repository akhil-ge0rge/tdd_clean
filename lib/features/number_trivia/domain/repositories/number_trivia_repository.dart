import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, Trivia>> getTriviaWithNumber({required int number});
  Future<Either<Failure, Trivia>> getTriviaRandom();
}
