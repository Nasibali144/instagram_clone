import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/service/service_locator.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'feed_page.dart';
import 'likes_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'upload_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController pageController = PageController();
  int currentPage = 0;

  AuthBloc authBloc = locator<AuthBloc>();
  PostBloc postBloc = locator<PostBloc>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider (
          create: (context) => authBloc,
        ),
        BlocProvider (
          create: (context) => postBloc,
        ),
      ],
      child: Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            const FeedPage(),
            const SearchPage(),
            UploadPage(pageController: pageController,),
            const LikesPage(),
            const ProfilePage(),
          ],
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: currentPage,
          backgroundColor: Colors.white54,
          activeColor: Colors.purple,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.add_box)),
            BottomNavigationBarItem(icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ],
          onTap: (index) {
            pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
