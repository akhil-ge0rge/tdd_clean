import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  Future<TriviaModel> getLastTrivia();
  Future<void> cacheTrivia(TriviaModel trivia);
}
