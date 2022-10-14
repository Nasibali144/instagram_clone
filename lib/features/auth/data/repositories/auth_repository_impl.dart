import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/datasources/cloud_storage_data_source.dart';
import 'package:instagram_clone/core/error/exception.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/platform/network_info.dart';
import 'package:instagram_clone/core/util/convertor.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_store_user_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/post/data/datasources/fire_store_post_data_source.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';

/// TODO: har bir funksiyada try catch bor shularni umumiy bir shablon funksiyani ichida yozadigan qilish kerak, shunda hamma funksiyda bir hil errorlarni yozib o'tirilmaydi

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final FireAuthDataSource fireAuth;
  final LocalAuthDataSource localAuth;
  final FireStoreUserDataSource fireStore;
  final CloudStorageDataSource cloudStorage;
  final FireStorePostDataSource fireStorePost;

  AuthRepositoryImpl({
    required this.fireAuth,
    required this.localAuth,
    required this.networkInfo,
    required this.fireStore,
    required this.cloudStorage,
    required this.fireStorePost,
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
  Future<Either<Failure, User>> signInUser(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        UserModel user = UserModel(fullName: "no name", email: email, password: password);
        user = Convertor.convertEntity(await fireAuth.signInUser(email, password), user);
        await localAuth.storeData(StorageKeys.UID, user.uid);

        /// TODO: Store DataService
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } catch(e) {
        print(e);
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
  Future<Either<Failure, User>> signUpUser(UserModel user) async {
    if (await networkInfo.isConnected) {
      try {
        user = Convertor.convertEntity(await fireAuth.signUpUser(user), user);
        await localAuth.storeData(StorageKeys.UID, user.uid);

        /// TODO: Store NotificationService
        // Map<String, String> params = await Utils.deviceParams();
        //
        // user.device_id = params["device_id"]!;
        // user.device_type = params["device_type"]!;
        // user.device_token = params["device_token"]!;

        await fireStore.storeUser(user);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectFailure());
    }
  }

  @override
  Future<Either<Failure, User>> loadUser() async {

    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);

        UserModel user = await fireStore.loadUser(uid);
        user.followersCount = await fireStore.followersCount(uid);
        user.followingCount = await fireStore.followingCount(uid);

        return Right(user);
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
  Future<Either<Failure, User>> updateUserPhoto(File image) async {
    if (await networkInfo.isConnected) {
      try {
        // load
        String uid = localAuth.loadData(StorageKeys.UID);
        UserModel user = await fireStore.loadUser(uid);

        // upload image
        String imageUrl = await cloudStorage.uploadUserImage(image);
        user.imageUrl = imageUrl;

        // update
        await fireStore.updateUser(uid, user);

        return Right(user);
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
  Future<Either<Failure, List<User>>> searchUsers(String keyword) async {
    if (await networkInfo.isConnected) {
      try {
        List<UserModel> users = [];
        // load
        String uid = localAuth.loadData(StorageKeys.UID);
        users = await fireStore.searchUser(keyword, uid);

        // remove me in searching user list
        users.removeWhere((element) => element.uid == uid);

        // read following users for me
        List<UserModel> following = await fireStore.followingUsers(uid);

        for(UserModel user in users){
          if(following.contains(user)){
            user.followed = true;
          }else{
            user.followed = false;
          }
        }

        return Right(users);
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
  Future<Either<Failure, User>> followUser(User someone) async {

    if (await networkInfo.isConnected) {
      try {
        UserModel someoneUser = Convertor.convertUserModel(someone);
        String uid = localAuth.loadData(StorageKeys.UID);

        UserModel user = await fireStore.loadUser(uid);
        user.followersCount = await fireStore.followersCount(uid);
        user.followingCount = await fireStore.followingCount(uid);

        // I followed to someone
        await fireStore.followUser(user, someoneUser);

        // I am in someone`s followers
        await fireStore.followUser(user, someoneUser);

        /// TODO: send notification someone
        someoneUser.followed = true;

        List<PostModel> posts = await fireStorePost.loadPosts(someoneUser.uid);

        for(int i = 0; i < posts.length; i++) {
          posts[i].isLiked = false;
          await fireStorePost.storeFeed(posts[i], uid);
        }

        return Right(someoneUser);
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
  Future<Either<Failure, User>> unfollowUser(User someone) async {
    if (await networkInfo.isConnected) {
      try {
        String uid = localAuth.loadData(StorageKeys.UID);

        // I un followed to someone
        await fireStore.unFollowUser(uid, someone.uid);

        // I am not in someone`s followers
        await fireStore.unFollowUser(someone.uid, uid);

        someone.followed = false;
        List<PostModel> list = await fireStorePost.loadPosts(someone.uid);

        for(PostModel post in list){
          fireStorePost.removeFeed(uid, post.id);
        }

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
