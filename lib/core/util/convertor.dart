import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Convertor {
  static UserModel convertEntity(auth.User authUser, UserModel user) {
    user.uid = authUser.uid;
    if(authUser.displayName != null) {
      user.fullName = authUser.displayName!;
    }
    user.email = authUser.email!;
    return user;
  }

  static UserModel convertModel(User user) {
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
}