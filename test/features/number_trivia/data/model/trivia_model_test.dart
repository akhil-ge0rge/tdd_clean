import 'dart:convert';

import 'package:clean_tdd_trivian/features/number_trivia/data/models/trivia_model.dart';
import 'package:clean_tdd_trivian/features/number_trivia/domain/entities/trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTriviaModel = TriviaModel(
    text: "text",
    number: 1,
    found: true,
    type: "trivia",
  );

  test('should be a subclass of Trivia entity', () {
    expect(tTriviaModel, isA<Trivia>());
  });

  group('fromJson', () {
    test('shound return a valid model when the json number is integer', () {
      Map<String, dynamic> jsonData = json.decode(fixture('trivia.json'));

      final model = TriviaModel.fromMap(jsonData);

      expect(model, tTriviaModel);
    });

    test(
      'shound return a valid model when the json number is regarded as double',
      () {
        Map<String, dynamic> jsonData = json.decode(
          fixture('trivia_double.json'),
        );

        final model = TriviaModel.fromMap(jsonData);

        expect(model, tTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tTriviaModel.toMap();
      final expectedMap = {
        "text": "text",
        "number": 1,
        "found": true,
        "type": "trivia",
      };
      expect(result, expectedMap);
    });
  });

  group('copyWith', () {
    test('should return a model with updated value', () {
      final result = tTriviaModel.copyWith(number: 2);

      expect(result.number, 2);
    });
  });
}
