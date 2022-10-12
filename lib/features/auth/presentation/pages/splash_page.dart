import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/features/auth/presentation/pages/signin_page.dart';
import 'package:instagram_clone/features/auth/presentation/pages/signup_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String id = "splash_page";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //
  // Widget _starterPage() {
  //   return StreamBuilder<User?>(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (context, snapshot) {
  //       if(snapshot.hasData) {
  //         Prefs.store(StorageKeys.UID, snapshot.data!.uid);
  //         return HomePage();
  //       } else {
  //         Prefs.remove(StorageKeys.UID);
  //         return SignInPage();
  //       }
  //     },
  //   );
  // }

  void _openSignInPage() => Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage())));

  // _initNotification() async {
  //   await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   await _firebaseMessaging.getToken().then((token) {
  //     if (kDebugMode) {
  //       print(token);
  //     }
  //     Prefs.store(StorageKeys.TOKEN, token!);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _openSignInPage();
    // _initNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF833AB4), Color(0xFFC13584),],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Expanded(
              child: Center(child: Text("Instagram", style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: "Billabong"),)),
            ),
            Text("All rights reserved", style: TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
