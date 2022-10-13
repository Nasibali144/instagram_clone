import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/core/constants/folders.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';

abstract class FireStorePostDataSource {
  String getPostId(String uid);
  Future<PostModel> storePost(PostModel post, String uid);
}

class FireStorePostDataSourceImpl implements FireStorePostDataSource {
  final FirebaseFirestore fireStore;

  FireStorePostDataSourceImpl({required this.fireStore});

  @override
  String getPostId(String uid) {
    return fireStore.collection(folderUsers).doc(uid).collection(folderPosts).doc().id;
  }

  @override
  Future<PostModel> storePost(PostModel post, String uid) async {

  }
}