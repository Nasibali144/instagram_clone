import 'package:equatable/equatable.dart';

class User extends Equatable {
  String uid = "";
  late String fullName;
  late String email;
  late String password;
  String? imageUrl;
  bool followed = false;
  int followersCount = 0;
  int followingCount = 0;

  String device_id = "";
  String device_type = "";
  String device_token = "";

  User({required this.fullName, required this.email, required this.password});

  @override
  List<Object> get props => [uid];



}