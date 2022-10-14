import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/datasources/cloud_storage_data_source.dart';
import 'package:instagram_clone/core/error/exception.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/platform/network_info.dart';
import 'package:instagram_clone/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:instagram_clone/features/post/data/datasources/fire_store_post_data_source.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final NetworkInfo networkInfo;
  final LocalAuthDataSource localAuth;
  final CloudStorageDataSource cloudStorage;
  final FireStorePostDataSource fireStorePost;

  PostRepositoryImpl({
    required this.fireStorePost,
    required this.cloudStorage,
    required this.localAuth,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> likePost() {
    // TODO: implement likePost
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> loadFeeds() {
    // TODO: implement loadFeeds
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> loadLikes() {
    // TODO: implement loadLikes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> loadPosts() {
    // TODO: implement loadPosts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removePost() {
    // TODO: implement removePost
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> storeFeed() {
    // TODO: implement storeFeed
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> storePost(File image, String caption) async {
    if (await networkInfo.isConnected) {
      try {

        return Right(someone);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      } catch(e) {
        return Left(OtherFailure(e.toString()));
      }
    } else {
      return Left(ConnectFailure());
    }
  }
}
