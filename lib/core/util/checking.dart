import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';

class Checking {
  static Either<Failure, bool> emailChecking(String email) {
    String format = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(format);
    bool result = regExp.hasMatch(email);
    if (result) return Right(result);
    return Left(InvalidEmailFailure());
  }

  static Either<Failure, bool> nameChecking(String name) {
    bool result = name.length > 3;

    if (result) return Right(result);
    return Left(InvalidEmailFailure());
  }

  static Either<Failure, bool> passwordChecking(String password, [int minLength = 6]) {
    if(password.isEmpty) {
      return Left(EmptyFieldFailure());
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    bool result = hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
    if (result) return Right(result);
    return Left(InvalidEmailFailure());
  }
}

class InvalidEmailFailure extends Failure {
  @override
  List<Object> get props => [];
}

class InvalidNameFailure extends Failure {
  @override
  List<Object> get props => [];
}

class InvalidPasswordFailure extends Failure {
  @override
  List<Object> get props => [];
}

class EmptyFieldFailure extends Failure {
  @override
  List<Object> get props => [];
}