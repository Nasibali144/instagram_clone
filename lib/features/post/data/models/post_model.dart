import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';

class PostModel extends Post{
  PostModel({required super.postImage, required super.caption});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    var post = PostModel(
        postImage: json['postImage'],
        caption: json['caption'],
    );
    post.uid = json["uid"];
    post.fullName = json["fullName"];
    post.id = json["id"];
    post.createdDate = json["createdDate"];
    post.isLiked = json["isLiked"];
    post.isMine = json["isMine"];
    post.imageUser = json["imageUser"];

    return post;
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fullName": fullName,
    "id": id,
    "postImage": postImage,
    "caption": caption,
    "createdDate": createdDate,
    "isLiked": isLiked,
    "isMine": isMine,
    "imageUser": imageUser,
  };

}