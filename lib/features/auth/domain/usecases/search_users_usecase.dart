import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/usecase/base_usecase.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/search_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/update_user_photo_params.dart';

class SearchUsersUseCase extends UseCase<List<User>, SearchParams> {
  AuthRepository authRepository;
  SearchUsersUseCase(this.authRepository);

  @override
  Future<Either<Failure, List<User>>> call(SearchParams params) async {
    return await authRepository.searchUsers(params.keyword);
  }
}