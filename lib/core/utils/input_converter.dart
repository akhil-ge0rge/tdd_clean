import 'dart:developer';

import 'package:clean_tdd_trivian/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> convertStringToInteger(String number) {
    try {
      int integer = int.parse(number);
      log(integer.toString());
      if (integer < 0) throw FormatException();

      return Right(int.parse(number));
    } on FormatException {
      return Left(
        InvalidInputFailure(message: 'Invalid Format', statusCode: 404),
      );
    }
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    required super.message,
    required super.statusCode,
  });
}
