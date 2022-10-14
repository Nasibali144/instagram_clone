import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/core/constants/folders.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';

abstract class FireStoreUserDataSource {
  Future<void> storeUser(UserModel user); // OK
  Future<UserModel> loadUser(String uid); //
  Future<void> updateUser(String uid, UserModel user);
  Future<List<UserModel>> searchUser(String keyword, String uid);
  Future<void> followUser(UserModel userOne, UserModel userTwo);
  Future<void> unFollowUser(String uidOne, String uidTwo);
  Future<int> followersCount(String uid);
  Future<int> followingCount(String uid);
  Future<List<UserModel>> followingUsers(String uid);
}

class FireStoreUserDataSourceImpl implements FireStoreUserDataSource {
  final FirebaseFirestore fireStore;

  FireStoreUserDataSourceImpl({required this.fireStore});

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
  Future<void> updateUser(String uid, UserModel user) async {
    await fireStore.collection(folderUsers).doc(uid).update(user.toJson());
  }

  @override
  Future<List<UserModel>> searchUser(String keyword, String uid) async {
    List<UserModel> users = [];
    var querySnapshot = await fireStore.collection(folderUsers).orderBy("fullName").startAt([keyword]).endAt(['$keyword\uf8ff']).get();
    for (var element in querySnapshot.docs) {
      users.add(UserModel.fromJson(element.data()));
    }
    return users;
  }

  @override
  Future<List<UserModel>> followingUsers(String uid) async{
    List<UserModel> following = [];
    var querySnapshot = await fireStore.collection(folderUsers).doc(uid).collection(folderFollowing).get();

    for (var result in querySnapshot.docs) {
      following.add(UserModel.fromJson(result.data()));
    }

    return following;
  }

  @override
  Future<void> followUser(UserModel userOne, UserModel userTwo) async {
    await fireStore.collection(folderUsers).doc(userOne.uid).collection(folderFollowing).doc(userTwo.uid).set(userTwo.toJson());
  }

  @override
  Future<void> unFollowUser(String uidOne, String uidTwo) async {
    await fireStore.collection(folderUsers).doc(uidOne).collection(folderFollowing).doc(uidTwo).delete();
  }

  @override
  Future<int> followersCount(String uid) async {
    var querySnapshot1 = await fireStore.collection(folderUsers).doc(uid).collection(folderFollowers).get();
    return querySnapshot1.docs.length;
  }

  @override
  Future<int> followingCount(String uid) async {
    var querySnapshot2 = await fireStore.collection(folderUsers).doc(uid).collection(folderFollowing).get();
    return querySnapshot2.docs.length;
  }
}

