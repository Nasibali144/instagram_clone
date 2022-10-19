import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/auth/presentation/pages/signin_page.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> items = [];
  User? user;

  // for user image
  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    authBloc.add(UpdateUserPhotoEvent(file: File(image!.path)));
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    authBloc.add(UpdateUserPhotoEvent(file: File(image!.path)));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  late PostBloc postBloc;
  late AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postBloc = BlocProvider.of<PostBloc>(context)..add(const LoadPostsEvent());
    authBloc = BlocProvider.of<AuthBloc>(context)..add(LoadUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if(state is LoadPostsStateSuccess) {
          setState(() {
            items = state.posts;
          });
        }
      },
      builder: (context, state) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is LoadUserSuccessState) {
              setState(() {
                user = state.user;
              });
            }

            if(state is UpdateUserPhotoSuccessState) {
              authBloc.add(LoadUserEvent());
            }

            if(state is SignOutSuccessState) {
              Navigator.pushReplacementNamed(context, SignInPage.id);
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Billabong",
                      fontSize: 30),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        authBloc.add(SignOutUserEvent());
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.black87,
                      ))
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // #avatar
                        Stack(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 2)),
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(75),
                                child: user?.imageUrl == null ||
                                        user!.imageUrl!.isEmpty
                                    ? const Image(
                                        image: AssetImage(
                                            "assets/images/user.png"),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image(
                                        image: NetworkImage(user!.imageUrl!),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Container(
                              height: 77.5,
                              width: 77.5,
                              alignment: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      _showPicker(context);
                                    },
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colors.purple,
                                    )),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // #name
                        Text(
                          user == null ? "" : user!.fullName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        // #email
                        Text(
                          user == null ? "" : user!.email,
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        // #statistics
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    text: "${items.length}\n",
                                    children: const [
                                      TextSpan(
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        text: "POST",
                                      )
                                    ]),
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    text: user == null
                                        ? "0"
                                        : "${user!.followersCount}\n",
                                    children: const [
                                      TextSpan(
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        text: "FOLLOWERS",
                                      )
                                    ]),
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    text: user == null
                                        ? "0"
                                        : user!.followingCount.toString() +
                                            "\n",
                                    children: [
                                      TextSpan(
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        text: "FOLLOWING",
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // #posts
                        Expanded(
                          child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return itemOfPost(index, context);
                              }),
                        ),
                      ],
                    ),
                  ),
                  if (state is AuthLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Column itemOfPost(int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onLongPress: () {},
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            imageUrl: items[index].postImage,
            placeholder: (context, url) => Container(
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Text(
          items[index].caption,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
