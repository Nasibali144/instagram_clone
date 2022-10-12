import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exception.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/platform/network_info.dart';
import 'package:instagram_clone/core/util/convertor.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final FireAuthDataSource fireAuth;
  final LocalAuthDataSource localAuth;

  AuthRepositoryImpl({
    required this.fireAuth,
    required this.localAuth,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    if (await networkInfo.isConnected) {
      try {
        var result = await fireAuth.deleteUser();
        localAuth.removeData(StorageKeys.UID);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInUser(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        User user = User(fullName: "no name", email: email, password: password);
        user = Convertor.convertEntity(
            await fireAuth.signInUser(email, password), user);
        await localAuth.storeData(StorageKeys.UID, user.uid);

        /// TODO: Store DataService
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signOutUser() async {
    if (await networkInfo.isConnected) {
      try {
        var result = await fireAuth.signOutUser();
        localAuth.removeData(StorageKeys.UID);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUpUser(User user) async {
    if (await networkInfo.isConnected) {
      try {
        user = Convertor.convertEntity(await fireAuth.signUpUser(user), user);
        await localAuth.storeData(StorageKeys.UID, user.uid);

        /// TODO: Store DataService
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectFailure());
    }
  }
}
