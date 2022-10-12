import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/service/service_locator.dart';
import 'package:instagram_clone/core/util/utility.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/pages/signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = "signup_page";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  AuthBloc bloc = locator<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF833AB4),
                      Color(0xFFC13584),
                    ],
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // #app_name
                          const Text(
                            "Instagram",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontFamily: "Billabong"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // #fullname
                          textField(
                              hintText: "FullName",
                              controller: fullNameController),
                          const SizedBox(
                            height: 10,
                          ),

                          // #email
                          textField(
                              hintText: "Email", controller: emailController),
                          const SizedBox(
                            height: 10,
                          ),

                          // #password
                          textField(
                              hintText: "Password",
                              controller: passwordController),
                          const SizedBox(
                            height: 10,
                          ),

                          // #password
                          textField(
                              hintText: "Confirm Password",
                              controller: confirmPasswordController),
                          const SizedBox(
                            height: 10,
                          ),

                          // #signin
                          button(title: "Sign Up", onPressed: () {
                            bloc.add(SignUpUserEvent(fullName: fullNameController.text, email: emailController.text, password: passwordController.text, confirmPassword: confirmPasswordController.text));
                          }),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, SignInPage.id);
                                },
                            )
                          ]),
                    )
                  ],
                ),
              ),
            ),

            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if(state is SignUpSuccessState) {
                  Utils.fireSnackBar("Successfully Sign Up", context);
                  Navigator.pushNamed(context, SignInPage.id);
                }
              },
              builder: (context, state) {
                if(state is AuthLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  ClipRRect textField(
      {required String hintText,
      bool? isHidden,
      required TextEditingController controller}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.5),
      child: TextField(
        style: const TextStyle(fontSize: 16, color: Colors.white),
        controller: controller,
        obscureText: isHidden ?? false,
        decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white54.withOpacity(0.2),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54)),
      ),
    );
  }

  MaterialButton button(
      {required String title, required void Function() onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.5),
        side: BorderSide(color: Colors.white54.withOpacity(0.2), width: 2),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
