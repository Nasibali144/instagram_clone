import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/like_post_params.dart';

class LikePostUseCase extends UseCase<Post, LikePostParams> {
  PostRepository postRepository;
  LikePostUseCase(this.postRepository);

  @override
  Future<Either<Failure, Post>> call(LikePostParams params) async {
    return await postRepository.likePost(params.post, params.liked);
  }
}