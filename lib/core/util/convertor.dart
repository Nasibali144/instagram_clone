import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Convertor {
  static User convertEntity(auth.User authUser, User user) {
    user.uid = authUser.uid;
    user.fullName = authUser.displayName!;
    user.email = authUser.email!;
    return user;
  }
}