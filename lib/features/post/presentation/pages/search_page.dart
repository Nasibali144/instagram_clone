import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<User> user = [];

  late AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = BlocProvider.of<AuthBloc>(context)
      ..add(const SearchUsersEvent(keyword: ""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is SearchUsersSuccessState) {
          setState(() {
            user = state.users;
          });
        }

        if(state is FollowUserSuccessState) {
          authBloc.add(const SearchUsersEvent(keyword: ""));
        }

        if(state is UnfollowUserSuccessState) {
          authBloc.add(const SearchUsersEvent(keyword: ""));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Search",
              style: TextStyle(
                  color: Colors.black, fontFamily: "Billabong", fontSize: 30),
            ),
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // #search
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
                    child: TextField(
                      controller: controller,
                      onChanged: (keyword) {
                        authBloc.add(SearchUsersEvent(keyword: keyword));
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),

                  // #users
                  Expanded(
                    child: ListView.builder(
                      itemCount: user.length,
                      itemBuilder: (context, index) => itemOfUser(user[index]),
                    ),
                  )
                ],
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
  }

  Widget itemOfUser(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.purpleAccent, width: 2)),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: user.imageUrl != null
                ? CachedNetworkImage(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    imageUrl: user.imageUrl!,
                    placeholder: (context, url) => const Image(
                        image: AssetImage("assets/images/user.png")),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : const Image(
                    image: AssetImage("assets/images/user.png"),
                    height: 40,
                    width: 40,
                  ),
          ),
        ),
        title: Text(
          user.fullName,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email,
            style: const TextStyle(
              color: Colors.black54,
            )),
        trailing: Container(
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: MaterialButton(
            onPressed: () {
              if(user.followed) {
                authBloc.add(UnfollowUserEvent(user: user));
              } else {
                authBloc.add(FollowUserEvent(user: user));
              }
            },
            child: Text(
              user.followed ? "Following" : "Follow",
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
