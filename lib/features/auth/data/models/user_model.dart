import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';

class UserModel extends User {
  UserModel({
    required super.fullName,
    required super.email,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var user = UserModel(
        fullName: json['fullName'],
        email: json['email'],
        password: json['password']
    );

    user.uid = json["uid"];
    user.imageUrl = json["imageUrl"];
    user.followersCount = json["followersCount"];
    user.followingCount = json["followingCount"];
    user.device_id = json['device_id']??"";
    user.device_type = json['device_type']??"";
    user.device_token = json['device_token']??"";
    return user;
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fullName": fullName,
    "email": email,
    "password": password,
    "imageUrl": imageUrl,
    "followingCount": followingCount,
    "followersCount": followersCount,
    'device_id': device_id,
    'device_type': device_type,
    'device_token': device_token,
  };
}
