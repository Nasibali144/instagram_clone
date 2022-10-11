import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';

class DeleteUserUseCase extends UseCase<bool, NoParams> {
  AuthRepository authRepository;
  DeleteUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.deleteUser();
  }
}
