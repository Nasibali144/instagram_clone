part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}
class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}
class PostError extends PostState {
  @override
  List<Object> get props => [];
}
class LikePostStateSuccess extends PostState {
  final Post post;
  final bool liked;

  const LikePostStateSuccess({required this.post, required this.liked});

  @override
  List<Object> get props => [post, liked];
}

class LoadFeedsStateSuccess extends PostState {
  final List<Post> feeds;

  const LoadFeedsStateSuccess({required this.feeds});

  @override
  List<Object> get props => [feeds];
}
class LoadLikesStateSuccess extends PostState {
  final List<Post> likes;
  const LoadLikesStateSuccess({required this.likes});

  @override
  List<Object> get props => [likes];
}
class LoadPostsStateSuccess extends PostState {
  final List<Post> posts;

  const LoadPostsStateSuccess({required this.posts});

  @override
  List<Object> get props => [];
}
class RemovePostStateSuccess extends PostState {
  final Post post;

  const RemovePostStateSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

class StorePostStateSuccess extends PostState {
  final File image;
  final String caption;
  const StorePostStateSuccess({required this.image,required this.caption});

  @override
  List<Object?> get props => [image,caption];
}

class GetImageStateSuccess extends PostState {
  final File image;
  const GetImageStateSuccess({required this.image});

  @override
  List<Object?> get props => [image];
}

class NavigatePageState extends PostState {
  final int page;
  const NavigatePageState({required this.page});

  @override
  List<Object?> get props => [page];
}

