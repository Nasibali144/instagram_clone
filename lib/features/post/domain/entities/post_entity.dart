import 'package:equatable/equatable.dart';

class Post extends Equatable {
  String uid = "";
  String fullName = "";
  String id = "";
  late String postImage;
  late String caption;
  String createdDate = "";
  bool isLiked = false;
  bool isMine = false;
  String? imageUser;

  Post({
    required this.postImage,
    required this.caption,
  });

  @override
  List<Object> get props => [uid, id];
}