import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/util/utility.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isLoading = false;
  List<Post> feeds = [];

  @override
  Widget build(BuildContext context) {
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
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              Post feed = feeds[index];
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
                        child: feed.imageUser != null ? CachedNetworkImage(
                          height: 40,
                          imageUrl: feed.imageUser!,
                          placeholder: (context, url) => const Image(image: AssetImage("assets/images/user.png")),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ) : const Image(image: AssetImage("assets/images/user.png"), height: 40,),
                      ),
                      title: Text(feed.fullName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                      subtitle: Text(Utils.getMonthDayYear(feed.createdDate), style: TextStyle(color: Colors.black)),
                      trailing: feed.isMine ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz, color: Colors.black, size: 30,),
                      ) : const SizedBox.shrink(),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          imageUrl: feed.postImage,
                          placeholder: (context, url) => Container(color: Colors.grey,),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),

                        if(_isLoading) const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(feed.isLiked ? Icons.favorite: Icons.favorite_outline, color: feed.isLiked? Colors.red: Colors.black, size: 27.5,),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.paperplane_fill, color: Colors.black, size: 27.5,),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text(feed.caption, style: TextStyle(color: Colors.black),),
                    )
                  ],
                ),
              );
            }
          ),

          if(_isLoading) const Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
