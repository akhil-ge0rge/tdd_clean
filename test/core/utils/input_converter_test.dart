import 'package:clean_tdd_trivian/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });
  group('convertStringToInteger', () {
    test('should return an integer when given string is an integer', () {
      final number = '123';

      final res = inputConverter.convertStringToInteger(number);

      expect(res, Right(123));
    });
    test('should throw a failure when given string is not integer', () {
      final number = 'asd';

      final res = inputConverter.convertStringToInteger(number);

      expect(
        res,
        Left(InvalidInputFailure(message: 'Invalid Format', statusCode: 404)),
      );
    });
    test('should throw a failure when given string is negative integer', () {
      final number = '-123';

      final res = inputConverter.convertStringToInteger(number);

      expect(
        res,
        Left(InvalidInputFailure(message: 'Invalid Format', statusCode: 404)),
      );
    });
  });
}
