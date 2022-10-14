import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/features/auth/data/models/user_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_up_params.dart';

class SignUpUserUseCase extends UseCase<User, SignUpParams> {
  AuthRepository authRepository;

  SignUpUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    UserModel user = UserModel(fullName: params.fullName, email: params.email, password: params.password);
    return await authRepository.signUpUser(user);
  }
}
