import 'dart:developer';

import 'package:clean_tdd_trivian/core/error/exceptions.dart';
import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDatasource {
  Future<TriviaModel> getTriviaWithNumber({required int number});
  Future<TriviaModel> getTriviaRandom();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl(this.client);

  @override
  Future<TriviaModel> getTriviaWithNumber({required int number}) async =>
      _getTriviaModel('http://numbersapi.com/$number?json');

  @override
  Future<TriviaModel> getTriviaRandom() async =>
      _getTriviaModel('http://numbersapi.com/random?json');

  Future<TriviaModel> _getTriviaModel(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      log(response.body);
      final tModel = TriviaModel.fromJson(response.body);
      return tModel;
    } else {
      throw ServerException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }
  }
}
