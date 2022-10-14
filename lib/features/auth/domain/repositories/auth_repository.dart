import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {

  // auth
  Future<Either<Failure, User>> signUpUser(UserModel user);
  Future<Either<Failure, User>> signInUser(String email, String password);
  Future<Either<Failure, bool>> signOutUser();
  Future<Either<Failure, bool>> deleteUser();

  // user
  Future<Either<Failure, User>> loadUser();
  Future<Either<Failure, User>> updateUserPhoto(File image);
  Future<Either<Failure, List<User>>> searchUsers(String keyword);
  Future<Either<Failure, User>> followUser(User someone);
  Future<Either<Failure, User>> unfollowUser(User someone);
}