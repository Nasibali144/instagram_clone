import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/core/service/service_locator.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController captionController = TextEditingController();

  // PostBloc postBloc = locator<PostBloc>();

  late PostBloc postBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postBloc = BlocProvider.of<PostBloc>(context);
  }


  // for image
  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    postBloc.add(GetImageEvent(image: File(image!.path)));
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    postBloc.add(GetImageEvent(image: File(image!.path)));
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Upload",
            style: TextStyle(
                color: Colors.black, fontFamily: "Billabong", fontSize: 30),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // widget.pageController!.jumpToPage(2);
              },
              icon: const Icon(
                Icons.post_add,
                color: Colors.purple,
                size: 27.5,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // #image
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          return Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey.shade300,
                            child: state is GetImageStateSuccess
                                ? Stack(
                                    children: [
                                      Image.file(
                                        state.image,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                      Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            postBloc.add(CancelImageEvent());
                                          },
                                          icon: const Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),

                    // #caption
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10.0),
                      child: TextField(
                        controller: captionController,
                        decoration: const InputDecoration(
                          hintText: "Caption",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
