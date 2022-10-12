import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/core/constants/folders.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';

abstract class FireStoreDataSource {
  Future<void> storeUser(UserModel user);
  Future<UserModel> loadUser(String uid);
  Future<void> updateUser(String uid, User user);
  Future<List<User>> searchUser(String keyword, String uid);
  Future<User> followUser(User userOne, User userTwo);
  Future<User> unFollowUser(String uidOne, String uidTwo);
  Future<int> followersCount(String uid);
  Future<int> followingCount(String uid);
  Future<List<UserModel>> followingUsers(String uid);
}

class FireStoreDataSourceImpl extends FireStoreDataSource {
  final FirebaseFirestore fireStore;

  FireStoreDataSourceImpl({required this.fireStore});

  @override
  Future<void> storeUser(UserModel user) async {
    return await fireStore.collection(folderUsers).doc(user.uid).set(user.toJson());
  }

  @override
  Future<UserModel> loadUser(String uid) async {
    var value = await fireStore.collection(folderUsers).doc(uid).get();
    UserModel user = UserModel.fromJson(value.data()!);
    return user;
  }

  @override
  Future<User> followUser(User userOne, User userTwo) {
    // TODO: implement followUser
    throw UnimplementedError();
  }

  @override
  Future<List<User>> searchUser(String keyword, String uid) {
    // TODO: implement searchUser
    throw UnimplementedError();
  }

  @override
  Future<User> unFollowUser(String uidOne, String uidTwo) {
    // TODO: implement unFollowUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(String uid, User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<int> followersCount(String uid) {
    // TODO: implement followersCount
    throw UnimplementedError();
  }

  @override
  Future<int> followingCount(String uid) {
    // TODO: implement followingCount
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> followingUsers(String uid) {
    // TODO: implement followingUsers
    throw UnimplementedError();
  }
}

