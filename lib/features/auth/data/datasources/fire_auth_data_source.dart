import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';

abstract class FireAuthDataSource {
  Future<User?> signUpUser(UserModel user);

  Future<User?> signInUser(String email, String password);

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
  Future<User?> signInUser(String email, String password) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<bool> signOutUser() async {
    await auth.signOut();
    return true;
  }

  @override
  Future<User?> signUpUser(UserModel user) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
    await auth.currentUser?.updateDisplayName(user.fullName);
    User? newUser = userCredential.user;
    return newUser;
  }
}
