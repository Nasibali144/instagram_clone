import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/core/error/exception.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart' as entity;

abstract class FireAuthDataSource {
  Future<User> signUpUser(entity.User user);

  Future<User> signInUser(String email, String password);

  Future<bool> signOutUser();

  Future<bool> deleteUser();
}

class FireAuthDataSourceIml extends FireAuthDataSource {
  final FirebaseAuth auth;

  FireAuthDataSourceIml({required this.auth});

  @override
  Future<bool> deleteUser() async {
    await auth.currentUser!.delete();
    return true;
  }

  @override
  Future<User> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      var user = userCredential.user;
      if(user != null) {
        return user;
      } else {
        throw ServerException();
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> signOutUser() async {
    await auth.signOut();
    return true;
  }

  @override
  Future<User> signUpUser(entity.User user) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
    await auth.currentUser?.updateDisplayName(user.fullName);
    User? newUser = userCredential.user;
    if(newUser != null) {
      return newUser;
    } else {
      throw ServerException();
    }
  }
}
