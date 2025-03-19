import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/core/usecases/usecase.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetTriviaWithNumber implements UseCase<Trivia, TrivianParams> {
  final NumberTriviaRepository repository;

  GetTriviaWithNumber({required this.repository});

  @override
  Future<Either<Failure, Trivia>> call(TrivianParams params) =>
      repository.getTriviaWithNumber(number: params.number);
}

class TrivianParams extends Equatable {
  final int number;

  const TrivianParams({required this.number});

  @override
  List<Object?> get props => [number];
}
