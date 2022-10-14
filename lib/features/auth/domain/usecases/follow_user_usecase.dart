import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/follow_params.dart';

class FollowUserUseCase extends UseCase<User, FollowParams> {
  AuthRepository authRepository;
  FollowUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(FollowParams params) async {
    return await authRepository.followUser(params.user);
  }
}