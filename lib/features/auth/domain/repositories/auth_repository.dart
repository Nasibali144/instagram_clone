import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUpUser(User user);
  Future<Either<Failure, User>> signInUser(String email, String password);
  Future<Either<Failure, bool>> signOutUser();
  Future<Either<Failure, void>> deleteUser();
}