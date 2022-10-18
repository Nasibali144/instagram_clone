import 'package:flutter/material.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<User> user = [];
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
