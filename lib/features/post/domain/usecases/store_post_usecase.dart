import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';
import 'package:instagram_clone/features/post/domain/usecases/params/store_post_params.dart';

class StorePostUseCase extends UseCase<bool, StorePostParams> {
  PostRepository postRepository;
  StorePostUseCase(this.postRepository);

  @override
  Future<Either<Failure, bool>> call(StorePostParams params) async {
    return await postRepository.storePost(params.image, params.caption);
  }
}