import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';

class RemovePostParams extends Equatable {
  final Post post;

  const RemovePostParams({
    required this.post,
  });

  @override
  List<Object?> get props => [post];
}