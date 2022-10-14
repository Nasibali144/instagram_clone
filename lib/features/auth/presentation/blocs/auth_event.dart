part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignUpUserEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpUserEvent({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [fullName, email, password, confirmPassword];
}

class SignInUserEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInUserEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignOutUserEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class DeleteUserEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class FollowUserEvent extends AuthEvent {
  final User user;

  const FollowUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class LoadUserEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SearchUsersEvent extends AuthEvent {
  final String keyword;

  const SearchUsersEvent({required this.keyword});

  @override
  List<Object> get props => [keyword];
}

class UnfollowUserEvent extends AuthEvent {
  final User user;

  const UnfollowUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserPhotoEvent extends AuthEvent {
  final File file;

  const UpdateUserPhotoEvent({required this.file});

  @override
  List<Object> get props => [file];
}