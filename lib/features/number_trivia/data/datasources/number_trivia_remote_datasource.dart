import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  Future<TriviaModel> getTriviaWithNumber({required int number});
  Future<TriviaModel> getTriviaRandom();
}
