import 'package:clean_tdd_trivian/core/error/exceptions.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late NumberTriviaLocalDatasource localDatasource;
  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDatasource = NumberTriviaLocalDatasourceImpl(sharedPreferences);
  });

  group('getLastTrivia', () {
    final tTriviaModel = TriviaModel.fromJson(fixture('trivia.json'));
    test(
      'should return trivia from SharedPreferences when there is one in the cache',
      () async {
        when(
          () => sharedPreferences.getString(any()),
        ).thenReturn(fixture('trivia.json'));
        final res = await localDatasource.getLastTrivia();

        expect(res, equals(tTriviaModel));

        verify(() => sharedPreferences.getString(cacheTriviaKey)).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      },
    );

    test(
      'should throw CacheException when there is no data in the SharedPreferences',
      () async {
        when(() => sharedPreferences.getString(any())).thenReturn(null);
        final call = localDatasource.getLastTrivia;

        expect(() => call(), throwsA(TypeMatcher<CacheException>()));

        verify(() => sharedPreferences.getString(cacheTriviaKey)).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      },
    );
  });

  group('cacheTrivia', () {
    final tTriviaModel = TriviaModel(
      text: "text",
      number: 1,
      found: true,
      type: "trivia",
    );
    final expectedJsonString = tTriviaModel.toJson();
    test('should call SharedPreferences to cache data', () async {
      when(
        () => sharedPreferences.setString(any(), any()),
      ).thenAnswer((invocation) async => true);

      await localDatasource.cacheTrivia(tTriviaModel);

      verify(
        () => sharedPreferences.setString(cacheTriviaKey, expectedJsonString),
      ).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });
}
