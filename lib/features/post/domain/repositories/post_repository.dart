import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, bool>> deleteUser();


}