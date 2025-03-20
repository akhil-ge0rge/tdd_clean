import 'package:clean_tdd_trivian/core/network/network_info.dart';
import 'package:clean_tdd_trivian/core/utils/input_converter.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_tdd_trivian/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_random_trivian.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/usecases/get_trivia_with_number.dart';
import 'package:clean_tdd_trivian/features/number_trivia/presentation/bloc/trivia_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  //BLOC
  sl
    ..registerFactory(
      () => TriviaBloc(
        getTriviaForNumber: sl(),
        getRandomTrivian: sl(),
        inputConverter: sl(),
      ),
    )
    // UseCases
    ..registerLazySingleton(() => GetTriviaWithNumber(repository: sl()))
    ..registerLazySingleton(() => GetRandomTrivian(repository: sl()))
    //Repository
    ..registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
        localDatasource: sl(),
        networkInfo: sl(),
        remoteDatasource: sl(),
      ),
    )
    //DataSources
    ..registerLazySingleton<NumberTriviaLocalDatasource>(
      () => NumberTriviaLocalDatasourceImpl(sl()),
    )
    ..registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceImpl(sl()),
    )
    //Core
    ..registerLazySingleton(() => InputConverter())
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()))
    //External
    ..registerLazySingleton(() => prefs)
    ..registerLazySingleton(() => Connectivity())
    ..registerLazySingleton(() => http.Client());
}
