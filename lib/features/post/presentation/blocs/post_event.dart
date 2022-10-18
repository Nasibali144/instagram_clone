part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class LikePostEvent extends PostEvent {
  final Post post;
  final bool liked;

  const LikePostEvent(this.post, this.liked);

  @override
  List<Object?> get props => [post, liked];
}

class LoadFeedsEvent extends PostEvent {
  const LoadFeedsEvent();

  @override
  List<Object?> get props => [];
}
class LoadLikesEvent extends PostEvent {
  const LoadLikesEvent();

  @override
  List<Object?> get props => [];
}
class LoadPostsEvent extends PostEvent {
  const LoadPostsEvent();

  @override
  List<Object?> get props => [];
}
class RemovePostEvent extends PostEvent {
  final Post post;
  const RemovePostEvent({required this.post});

  @override
  List<Object?> get props => [post];
}
class StorePostEvent extends PostEvent {
  final File image;
  final String caption;
  const StorePostEvent({required this.image,required this.caption});

  @override
  List<Object?> get props => [image,caption];
}

class GetImageEvent extends PostEvent {
  final File image;
  const GetImageEvent({required this.image});

  @override
  List<Object?> get props => [image];
}

class CancelImageEvent extends PostEvent {
  @override
  List<Object> get props => [];
}

class NavigatePageEvent extends PostEvent {
  final int page;

  const NavigatePageEvent({required this.page});

  @override
  List<Object> get props => [page];
}
