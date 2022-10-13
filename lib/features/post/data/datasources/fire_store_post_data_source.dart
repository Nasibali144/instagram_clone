import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/core/constants/folders.dart';
import 'package:instagram_clone/features/post/data/models/post_model.dart';

abstract class FireStorePostDataSource {
  String getPostId(String uid);
  Future<void> storePost(PostModel post);
  Future<void> storeFeed(PostModel post, String uid);
  Future<List<PostModel>> loadFeeds(String uid);
  Future<List<PostModel>> loadPosts(String uid);
  Future<void> updatePost(PostModel post);
  Future<void> updateFeed(PostModel post, String uid);
  Future<List<PostModel>> loadLikes(String uid);
  Future<void> removeFeed(String uid, String postId);
  Future<void> removePost(String uid, String postId);
}

class FireStorePostDataSourceImpl implements FireStorePostDataSource {
  final FirebaseFirestore fireStore;

  FireStorePostDataSourceImpl({required this.fireStore});

  @override
  String getPostId(String uid) {
    return fireStore.collection(folderUsers).doc(uid).collection(folderPosts).doc().id;
  }

  @override
  Future<void> storePost(PostModel post) async {
    await fireStore.collection(folderUsers).doc(post.uid).collection(folderPosts).doc(post.id).set(post.toJson());
  }

  @override
  Future<void> storeFeed(PostModel post, String uid) async {
    await fireStore.collection(folderUsers).doc(uid).collection(folderFeeds).doc(post.id).set(post.toJson());
  }

  @override
  Future<List<PostModel>> loadFeeds(String uid) async {
    List<PostModel> posts = [];
    var querySnapshot = await fireStore.collection(folderUsers).doc(uid).collection(folderFeeds).get();

    for (var element in querySnapshot.docs) {
      PostModel post = PostModel.fromJson(element.data());
      if(post.uid == uid) post.isMine = true;
      posts.add(post);
    }

    return posts;
  }

  @override
  Future<List<PostModel>> loadPosts(String uid) async {
    List<PostModel> posts = [];
    var querySnapshot = await fireStore.collection(folderUsers).doc(uid).collection(folderPosts).get();

    for (var element in querySnapshot.docs) {
      posts.add(PostModel.fromJson(element.data()));
    }
    return posts;
  }

  @override
  Future<void> updateFeed(PostModel post, String uid) async {
    await fireStore.collection(folderUsers).doc(uid).collection(folderFeeds).doc(post.id).update(post.toJson());
  }

  @override
  Future<void> updatePost(PostModel post) async {
    await fireStore.collection(folderUsers).doc(post.uid).collection(folderPosts).doc(post.id).update(post.toJson());
  }

  @override
  Future<List<PostModel>> loadLikes(String uid) async {
    List<PostModel> posts = [];

    var querySnapshot = await fireStore.collection(folderUsers).doc(uid).collection(folderFeeds).where("isLiked", isEqualTo: true).get();

    for (var element in querySnapshot.docs) {
      PostModel post = PostModel.fromJson(element.data());
      if(post.uid == uid) post.isMine = true;
      posts.add(post);
    }

    return posts;
  }

  @override
  Future<void> removeFeed(String uid, String postId) async {
    await fireStore.collection(folderUsers).doc(uid).collection(folderFeeds).doc(postId).delete();
  }

  @override
  Future<void> removePost(String uid, String postId) async {
    await fireStore.collection(folderUsers).doc(uid).collection(folderPosts).doc(postId).delete();
  }
}