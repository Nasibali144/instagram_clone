import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:instagram_clone/features/post/data/models/post_model.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';

class Convertor {
  static UserModel convertEntity(auth.User authUser, UserModel user) {
    user.uid = authUser.uid;
    if(authUser.displayName != null) {
      user.fullName = authUser.displayName!;
    }
    user.email = authUser.email!;
    return user;
  }

  static UserModel convertUserModel(User user) {
    UserModel userModel = UserModel(fullName: user.fullName, email: user.email, password: user.password);
    userModel.uid = user.uid;
    userModel.imageUrl = user.imageUrl;
    userModel.followersCount = user.followersCount;
    userModel.followingCount = user.followingCount;
    userModel.device_id = user.device_id;
    userModel.device_type = user.device_type;
    userModel.device_token = user.device_token;

    return userModel;
  }

  static PostModel convertPostModel(Post post) {
    PostModel postModel = PostModel(postImage: post.postImage, caption: post.caption);

    postModel.uid = post.uid;
    postModel.fullName = post.fullName;
    postModel.id = post.id;
    postModel.createdDate = post.createdDate;
    postModel.isLiked = post.isLiked;
    postModel.isMine = post.isMine;
    postModel.imageUser = post.imageUser;

    return postModel;
  }
}