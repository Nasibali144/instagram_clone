import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';

class FollowParams extends Equatable {
  final User user;

  const FollowParams({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}