import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, bool>> storePost(File image, String caption);
  Future<Either<Failure, void>> storeFeed();
  Future<Either<Failure, void>> loadFeeds();
  Future<Either<Failure, void>> loadPosts();
  Future<Either<Failure, void>> likePost();
  Future<Either<Failure, void>> loadLikes();
  Future<Either<Failure, void>> removePost();
}