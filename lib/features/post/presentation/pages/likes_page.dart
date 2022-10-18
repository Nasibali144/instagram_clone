import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/util/utility.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<Post> likes = [];

  late PostBloc postBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postBloc = BlocProvider.of<PostBloc>(context)..add(const LoadLikesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if(state is LoadLikesStateSuccess) {
          setState(() {
            likes = state.likes;
          });
        }

        if(state is LikePostStateSuccess) {
          postBloc.add(const LoadLikesEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Instagram",
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
                    Icons.camera_alt,
                    color: Colors.black,
                  ))
            ],
          ),
          body: Stack(
            children: [
              ListView.builder(
                  itemCount: likes.length,
                  itemBuilder: (context, index) {
                    Post feed = likes[index];
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: feed.imageUser != null
                                  ? CachedNetworkImage(
                                height: 40,
                                imageUrl: feed.imageUser!,
                                placeholder: (context, url) =>
                                const Image(
                                    image: AssetImage(
                                        "assets/images/user.png")),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              )
                                  : const Image(
                                image:
                                AssetImage("assets/images/user.png"),
                                height: 40,
                              ),
                            ),
                            title: Text(
                              feed.fullName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                Utils.getMonthDayYear(feed.createdDate),
                                style: TextStyle(color: Colors.black)),
                            trailing: feed.isMine
                                ? IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.black,
                                size: 30,
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedNetworkImage(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                imageUrl: feed.postImage,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              if (state is PostLoading)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  postBloc.add(LikePostEvent(feed, !feed.isLiked));
                                },
                                icon: Icon(
                                  feed.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color:
                                  feed.isLiked ? Colors.red : Colors.black,
                                  size: 27.5,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  CupertinoIcons.paperplane_fill,
                                  color: Colors.black,
                                  size: 27.5,
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              feed.caption,
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
              if (state is PostLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        );
      },
    );
  }
}
