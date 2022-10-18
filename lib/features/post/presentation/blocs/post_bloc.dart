import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/domain/usecases/like_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_feeds_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_likes_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_posts_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/like_post_params.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/remove_post_params.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/store_post_params.dart';
import 'package:instagram_clone/features/post/domain/usecases/remove_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/store_post_usecase.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  LikePostUseCase likePostUseCase;
  LoadFeedsUseCase loadFeedsUseCase;
  LoadLikesUseCase loadLikesUseCase;
  LoadPostsUseCase loadPostsUseCase;
  RemovePostUseCase removePostUseCase;
  StorePostUseCase storePostUseCase;

  PostBloc({
    required this.likePostUseCase,
    required this.loadFeedsUseCase,
    required this.loadLikesUseCase,
    required this.loadPostsUseCase,
    required this.removePostUseCase,
    required this.storePostUseCase,
  }) : super(PostInitial()) {
    on<LikePostEvent>(likePost);
    on<LoadFeedsEvent>(loadFeeds);
    on<LoadLikesEvent>(loadLikes);
    on<LoadPostsEvent>(loadPost);
    on<RemovePostEvent>(removePost);
    on<StorePostEvent>(storePost);
    on<GetImageEvent>(getImage);
    on<CancelImageEvent>(cancelImage);
  }

  void likePost(LikePostEvent event, Emitter<PostState> emit)async {
    emit(PostLoading());
    final failureOrLike = await likePostUseCase(LikePostParams(post: event.post, liked: event.liked));
    failureOrLike.fold((failure) => emit(PostError()), (result) => emit(LikePostStateSuccess(post: event.post, liked: event.liked)));
  }

  void loadFeeds(LoadFeedsEvent event, Emitter<PostState> emit) async{
    emit(PostLoading());
    final failureOrLike = await loadFeedsUseCase(NoParams());
    failureOrLike.fold((failure) => emit(PostError()), (result) => emit(LoadFeedsStateSuccess(feeds: result)));
  }

  void loadPost(LoadPostsEvent event, Emitter<PostState> emit) async{
    emit(PostLoading());
    final failureOrLoadPost = await loadPostsUseCase(NoParams());
    failureOrLoadPost.fold((failure) => emit(PostError()), (result) => emit(LoadPostsStateSuccess(posts: result)));
  }

  void loadLikes(LoadLikesEvent event, Emitter<PostState> emit) async{
    emit(PostLoading());
    final failureOrLoadLike = await loadLikesUseCase(NoParams());
    failureOrLoadLike.fold((failure) => emit(PostError()), (result) => emit(LoadLikesStateSuccess(likes: result)));
  }

  void removePost(RemovePostEvent event, Emitter<PostState> emit) async{
    emit(PostLoading());
    final failureOrRemovePost = await removePostUseCase(RemovePostParams(post: event.post));
    failureOrRemovePost.fold((failure) => emit(PostError()), (result) => emit( RemovePostStateSuccess(post: event.post)));
  }

  void storePost(StorePostEvent event, Emitter<PostState> emit)async {
    emit(PostLoading());
    final failureOrStorePost = await storePostUseCase(StorePostParams(image: event.image, caption: event.caption));
    failureOrStorePost.fold((failure) => emit(PostError()), (result) {
      emit(const NavigatePageState(page: 0));
    });
  }


  void getImage(GetImageEvent event, Emitter<PostState> emit)async {
    emit(GetImageStateSuccess(image: event.image));
  }

  void cancelImage(CancelImageEvent event, Emitter<PostState> emit)async {
    // TODO: this code will be changed
    emit(PostInitial());
  }
}
