import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';

class LikePostParams extends Equatable {
  final Post post;
  final bool liked;

  const LikePostParams({
    required this.post,
    required this.liked,
  });

  @override
  List<Object?> get props => [post, liked];
}