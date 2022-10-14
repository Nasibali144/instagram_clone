import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, bool>> storePost(File image, String caption);
  Future<Either<Failure, List<Post>>> loadPosts();
  Future<Either<Failure, List<Post>>> loadFeeds();
  Future<Either<Failure, List<Post>>> loadLikes();
  Future<Either<Failure, Post>> likePost(Post post, bool liked);
  Future<Either<Failure, void>> removePost(Post post);
}