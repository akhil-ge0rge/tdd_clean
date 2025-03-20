import 'dart:developer';

import 'package:clean_tdd_trivian/features/number_trivia/presentation/bloc/trivia_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({super.key});

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  final numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Number Trivia")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 10),
            BlocBuilder<TriviaBloc, TriviaState>(
              builder: (context, state) {
                log(state.toString());
                if (state is TriviaLoading) {
                  return CircularProgressIndicator.adaptive();
                } else if (state is TriviaSucess) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.maxFinite,

                    child: Column(
                      children: [
                        Text(
                          "Start Searching",

                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Text(
                              state.trivia.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is TriviaFailure) {
                  return Text(state.message);
                } else {
                  return ErrorWidget("Another Dimension");
                }
              },
            ),
            SizedBox(height: 10),
            Column(
              children: [
                TextField(controller: numberController),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TriviaBloc>().add(
                            GetTriviaForNumber(number: numberController.text),
                          );
                          numberController.clear();
                        },
                        child: Text("Get Trivia"),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          numberController.clear();
                          context.read<TriviaBloc>().add(GetTriviaForRandom());
                        },
                        child: Text("Random Trivia"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
