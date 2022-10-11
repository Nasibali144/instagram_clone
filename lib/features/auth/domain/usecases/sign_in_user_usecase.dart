import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_in_params.dart';

class SignInUserUseCase extends UseCase<User, SignInParams> {
  AuthRepository authRepository;
  SignInUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await authRepository.signInUser(params.email, params.password);
  }
}
