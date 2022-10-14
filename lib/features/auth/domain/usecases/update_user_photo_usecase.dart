import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/update_user_photo_params.dart';

class UpdateUserPhotoUserUseCase extends UseCase<User, UpdateUserPhotoParams> {
  AuthRepository authRepository;
  UpdateUserPhotoUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UpdateUserPhotoParams params) async {
    return await authRepository.updateUserPhoto(params.image);
  }
}