import 'package:clean_tdd_trivian/features/number_trivia/presentation/bloc/trivia_bloc.dart';
import 'package:clean_tdd_trivian/features/number_trivia/presentation/page/trivia_page.dart';
import 'package:clean_tdd_trivian/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TriviaBloc>()..add(GetTriviaForRandom()),
      child: MaterialApp(
        title: "Number Trivia",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade800,
            secondary: Colors.green.shade600,
          ),
        ),
        home: TriviaPage(),
      ),
    );
  }
}
