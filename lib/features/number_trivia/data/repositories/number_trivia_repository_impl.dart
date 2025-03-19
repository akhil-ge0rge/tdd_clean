import 'package:clean_tdd_trivian/core/error/exceptions.dart';
import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/core/network/network_info.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChoose = Future<TriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, Trivia>> getTriviaRandom() async {
    return _getTrivia(() {
      return remoteDatasource.getTriviaRandom();
    });
  }

  @override
  Future<Either<Failure, Trivia>> getTriviaWithNumber({
    required int number,
  }) async {
    return _getTrivia(() {
      return remoteDatasource.getTriviaWithNumber(number: number);
    });
  }

  Future<Either<Failure, TriviaModel>> _getTrivia(
    _ConcreteOrRandomChoose getTrivia,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await getTrivia();
        await localDatasource.cacheTrivia(res);
        return Right(res);
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message, statusCode: e.statusCode),
        );
      }
    } else {
      try {
        final res = await localDatasource.getLastTrivia();
        return Right(res);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
      }
    }
  }
}
