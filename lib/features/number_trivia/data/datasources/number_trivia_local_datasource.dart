import 'package:clean_tdd_trivian/core/error/exceptions.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDatasource {
  Future<TriviaModel> getLastTrivia();
  Future<void> cacheTrivia(TriviaModel trivia);
}

const cacheTriviaKey = 'cache_trivia';

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheTrivia(TriviaModel trivia) async {
    await sharedPreferences.setString(cacheTriviaKey, trivia.toJson());
  }

  @override
  Future<TriviaModel> getLastTrivia() {
    final jsonString = sharedPreferences.getString(cacheTriviaKey);

    if (jsonString != null) {
      return Future.value(TriviaModel.fromJson(jsonString));
    } else {
      throw CacheException(message: 'No Data Found');
    }
  }
}
