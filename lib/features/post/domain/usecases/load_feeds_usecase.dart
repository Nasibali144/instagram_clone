import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/post/domain/entities/post_entity.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';

class LoadFeedsUseCase extends UseCase<List<Post>, NoParams> {
  PostRepository postRepository;
  LoadFeedsUseCase(this.postRepository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await postRepository.loadFeeds();
  }
}