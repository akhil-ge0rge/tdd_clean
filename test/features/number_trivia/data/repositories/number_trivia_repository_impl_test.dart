import 'package:clean_tdd_trivian/core/error/exceptions.dart';
import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/core/network/network_info.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSources extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSources extends Mock
    implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRemoteDatasource remoteDatasource;
  late NumberTriviaLocalDatasource localDatasource;
  late NetworkInfo networkInfo;
  late NumberTriviaRepositoryImpl repositoryImpl;
  setUp(() {
    remoteDatasource = MockRemoteDataSources();
    localDatasource = MockLocalDataSources();
    networkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      networkInfo: networkInfo,
    );
  });

  group('getTriviaWithNumber', () {
    final tNumber = 1;
    final tTriviaModel = TriviaModel(
      text: 'text',
      number: 1,
      found: true,
      type: "type",
    );
    final Trivia tTrivia = tTriviaModel;

    test('should check if the device is online', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () =>
            remoteDatasource.getTriviaWithNumber(number: any(named: 'number')),
      ).thenAnswer((_) async => tTriviaModel);
      when(
        () => localDatasource.cacheTrivia(tTriviaModel),
      ).thenAnswer((_) async => Future.value());
      await repositoryImpl.getTriviaWithNumber(number: tNumber);

      verify(() => networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when call to remote datasource is success',
        () async {
          when(
            () => remoteDatasource.getTriviaWithNumber(
              number: any(named: 'number'),
            ),
          ).thenAnswer((invocation) async => tTriviaModel);
          when(
            () => localDatasource.cacheTrivia(tTriviaModel),
          ).thenAnswer((_) async => Future.value());

          final result = await repositoryImpl.getTriviaWithNumber(
            number: tNumber,
          );

          expect(result, equals(Right(tTrivia)));
          verify(
            () => remoteDatasource.getTriviaWithNumber(number: tNumber),
          ).called(1);
          verify(() => localDatasource.cacheTrivia(tTriviaModel)).called(1);

          verifyNoMoreInteractions(remoteDatasource);
          verifyNoMoreInteractions(localDatasource);
        },
      );

      test(
        'should cache data when call to remote datasource is success',
        () async {
          when(
            () => remoteDatasource.getTriviaWithNumber(
              number: any(named: 'number'),
            ),
          ).thenAnswer((invocation) async => tTriviaModel);
          when(
            () => localDatasource.cacheTrivia(tTriviaModel),
          ).thenAnswer((_) async => Future.value());
          await repositoryImpl.getTriviaWithNumber(number: tNumber);

          verify(
            () => remoteDatasource.getTriviaWithNumber(number: tNumber),
          ).called(1);
          verify(() => localDatasource.cacheTrivia(tTriviaModel)).called(1);

          verifyNoMoreInteractions(remoteDatasource);
          verifyNoMoreInteractions(localDatasource);
        },
      );

      test(
        'should return server failure when call to remote datasource is unsuccessful',
        () async {
          when(
            () => remoteDatasource.getTriviaWithNumber(
              number: any(named: 'number'),
            ),
          ).thenThrow(ServerException(message: "message", statusCode: 123));
          final result = await repositoryImpl.getTriviaWithNumber(
            number: tNumber,
          );

          expect(
            result,
            equals(Left(ServerFailure(message: 'message', statusCode: 123))),
          );
          verify(
            () => remoteDatasource.getTriviaWithNumber(number: tNumber),
          ).called(1);

          verifyNoMoreInteractions(remoteDatasource);
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last data locally cached data when the cached data is present',
        () async {
          when(
            () => localDatasource.getLastTrivia(),
          ).thenAnswer((_) async => tTriviaModel);

          final result = await repositoryImpl.getTriviaWithNumber(
            number: tNumber,
          );
          expect(result, equals(Right(tTrivia)));
          verify(() => localDatasource.getLastTrivia()).called(1);
          verifyNoMoreInteractions(localDatasource);
        },
      );

      test(
        'should return CacheFailure when there is no cached data is present',
        () async {
          when(
            () => localDatasource.getLastTrivia(),
          ).thenThrow(CacheException(message: 'No Data Found'));

          final result = await repositoryImpl.getTriviaWithNumber(
            number: tNumber,
          );
          expect(
            result,
            equals(
              Left(CacheFailure(message: 'No Data Found', statusCode: 500)),
            ),
          );
          verify(() => localDatasource.getLastTrivia()).called(1);
          verifyNoMoreInteractions(localDatasource);
        },
      );
    });
  });

  group('randomNumberTrivia', () {
    final tTriviaModel = TriviaModel(
      text: 'text',
      number: 1,
      found: true,
      type: "type",
    );
    final Trivia tTrivia = tTriviaModel;

    test('should check the device is online', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);

      when(
        () => remoteDatasource.getTriviaRandom(),
      ).thenAnswer((_) async => tTriviaModel);

      when(
        () => localDatasource.cacheTrivia(tTriviaModel),
      ).thenAnswer((invocation) async => Future.value());

      await repositoryImpl.getTriviaRandom();

      verify(() => networkInfo.isConnected).called(1);
    });

    group('device is online', () {
      setUp(() {
        when(
          () => networkInfo.isConnected,
        ).thenAnswer((invocation) async => true);
      });
      test(
        'should return a data when call to remote data source is sucessfull',
        () async {
          when(
            () => remoteDatasource.getTriviaRandom(),
          ).thenAnswer((_) async => tTriviaModel);
          when(
            () => localDatasource.cacheTrivia(tTriviaModel),
          ).thenAnswer((invocation) async => Future.value());

          final res = await repositoryImpl.getTriviaRandom();

          expect(res, equals(Right(tTrivia)));

          verify(() => remoteDatasource.getTriviaRandom()).called(1);
          verify(() => localDatasource.cacheTrivia(tTriviaModel)).called(1);
          verifyNoMoreInteractions(remoteDatasource);
          verifyNoMoreInteractions(localDatasource);
        },
      );

      test(
        'should cache data when call to remote data source is sucessfull',
        () async {
          when(
            () => remoteDatasource.getTriviaRandom(),
          ).thenAnswer((_) async => tTriviaModel);
          when(
            () => localDatasource.cacheTrivia(tTriviaModel),
          ).thenAnswer((invocation) async => Future.value());
          await repositoryImpl.getTriviaRandom();
          verify(() => remoteDatasource.getTriviaRandom()).called(1);
          verify(() => localDatasource.cacheTrivia(tTriviaModel)).called(1);
          verifyNoMoreInteractions(remoteDatasource);
          verifyNoMoreInteractions(localDatasource);
        },
      );

      test(
        'should return ServerFailure when call to remote data source is unsucessfull',
        () async {
          when(() => remoteDatasource.getTriviaRandom()).thenThrow(
            ServerException(message: 'something went wrong', statusCode: 404),
          );
          final res = await repositoryImpl.getTriviaRandom();

          expect(
            res,
            equals(
              Left(
                ServerFailure(message: 'something went wrong', statusCode: 404),
              ),
            ),
          );

          verify(() => remoteDatasource.getTriviaRandom()).called(1);

          verifyNoMoreInteractions(remoteDatasource);
        },
      );
    });

    group('device is ofline', () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return localy cached data when there is cahced data present',
        () async {
          when(
            () => localDatasource.getLastTrivia(),
          ).thenAnswer((_) async => tTriviaModel);

          final res = await repositoryImpl.getTriviaRandom();

          expect(res, equals(Right(tTriviaModel)));
          verify(() => localDatasource.getLastTrivia()).called(1);
          verifyNoMoreInteractions(localDatasource);
        },
      );

      test(
        'should return CacheFailure when there is no cached data is present',
        () async {
          when(
            () => localDatasource.getLastTrivia(),
          ).thenThrow(CacheException(message: 'No Data Found'));

          final res = await repositoryImpl.getTriviaRandom();

          expect(
            res,
            equals(
              Left(CacheFailure(message: 'No Data Found', statusCode: 500)),
            ),
          );

          verify(() => localDatasource.getLastTrivia()).called(1);
          verifyNoMoreInteractions(localDatasource);
        },
      );
    });
  });
}
