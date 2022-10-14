import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/datasources/cloud_storage_data_source.dart';
import 'package:instagram_clone/core/error/exception.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/platform/network_info.dart';
import 'package:instagram_clone/core/util/convertor.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_store_user_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/post/data/datasources/fire_store_post_data_source.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final NetworkInfo networkInfo;
  final LocalAuthDataSource localAuth;
  final CloudStorageDataSource cloudStorage;
  final FireStorePostDataSource fireStorePost;
  final FireStoreUserDataSource fireStoreUser;

  PostRepositoryImpl({
    required this.fireStorePost,
    required this.cloudStorage,
    required this.localAuth,
    required this.networkInfo,
    required this.fireStoreUser,
  });

  @override
  Future<Either<Failure, List<Post>>> loadFeeds() async {
    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);
        List<PostModel> feeds = await fireStorePost.loadFeeds(uid);

        return Right(feeds);
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

  @override
  Future<Either<Failure, List<Post>>> loadLikes() async {
    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);
        List<PostModel> posts = await fireStorePost.loadLikes(uid);

        return Right(posts);
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

  @override
  Future<Either<Failure, List<Post>>> loadPosts() async {
    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);
        List<PostModel> posts = await fireStorePost.loadPosts(uid);

        return Right(posts);
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

  @override
  Future<Either<Failure, void>> removePost(Post post) async  {
    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);
        await fireStorePost.removeFeed(uid, post.id);
        await fireStorePost.removePost(uid, post.id);
        return const Right(null);
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

  @override
  Future<Either<Failure, bool>> storePost(File image, String caption) async {
    if (await networkInfo.isConnected) {
      try {
        String imageUrl = await cloudStorage.uploadPostImage(image);
        PostModel post = PostModel(postImage: imageUrl, caption: caption);
        String uid = localAuth.loadData(StorageKeys.UID);
        UserModel user = await fireStoreUser.loadUser(uid);

        post.uid = user.uid;
        post.fullName = user.fullName;
        post.imageUser = user.imageUrl;
        post.createdDate = DateTime.now().toString();

        String postId = fireStorePost.getPostId(uid);
        post.id = postId;
        await fireStorePost.storePost(post);
        await fireStorePost.storeFeed(post, uid);

        return const Right(true);
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

  @override
  Future<Either<Failure, Post>> likePost(Post post, bool liked) async {
    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);
        post.isLiked = liked;
        PostModel postModel = Convertor.convertPostModel(post);
        await fireStorePost.updateFeed(postModel, uid);

        if(uid == post.uid) {
          await fireStorePost.updatePost(postModel);
        }

        return Right(postModel);
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
