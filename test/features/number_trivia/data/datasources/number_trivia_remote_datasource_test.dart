import 'package:clean_tdd_trivian/core/error/exceptions.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClinet extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late NumberTriviaRemoteDatasource remoteDatasource;

  // Use setUpAll() for one-time setup tasks that don't require resetting between tests.
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  //Use setUp() when you need clean, fresh instances for every test.
  setUp(() {
    client = MockHttpClinet();
    remoteDatasource = NumberTriviaRemoteDatasourceImpl(client);
  });

  void setUpMockHttpClientSuccess200() {
    when(
      () => client.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(
      () => client.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('server exception', 404));
  }

  group('getTriviaWithNumber', () {
    final tNumber = 1;
    final tTriviaModel = TriviaModel.fromJson(fixture('trivia.json'));

    test(
      '''should perform a GET request on a URL with number
    being the endpoint and the application/json header''',
      () async {
        setUpMockHttpClientSuccess200();

        await remoteDatasource.getTriviaWithNumber(number: tNumber);

        verify(
          () => client.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should return TriviaModel when the response is 200 (Sucess)',
      () async {
        setUpMockHttpClientSuccess200();

        final res = await remoteDatasource.getTriviaWithNumber(number: tNumber);

        expect(res, equals(tTriviaModel));

        verify(
          () => client.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw ServerException when the response is not 200 (failure)',
      () async {
        setUpMockHttpClientFailure();

        final call = remoteDatasource.getTriviaWithNumber;

        expect(
          () => call(number: tNumber),
          throwsA(TypeMatcher<ServerException>()),
        );

        verify(
          () => client.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
  group('getTriviaRandom', () {
    final tTriviaModel = TriviaModel.fromJson(fixture('trivia.json'));

    test(
      '''should perform a GET request on a URL with number
    being the endpoint and the application/json header''',
      () async {
        setUpMockHttpClientSuccess200();

        await remoteDatasource.getTriviaRandom();

        verify(
          () => client.get(
            Uri.parse('http://numbersapi.com/random?json'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should return TriviaModel when the response is 200 (Sucess)',
      () async {
        setUpMockHttpClientSuccess200();

        final res = await remoteDatasource.getTriviaRandom();

        expect(res, equals(tTriviaModel));

        verify(
          () => client.get(
            Uri.parse('http://numbersapi.com/random?json'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw ServerException when the response is not 200 (failure)',
      () async {
        setUpMockHttpClientFailure();

        final call = remoteDatasource.getTriviaRandom();

        expect(() => call, throwsA(TypeMatcher<ServerException>()));

        verify(
          () => client.get(
            Uri.parse('http://numbersapi.com/random?json'),
            headers: {'Content-Type': 'application/json'},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}
