part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  @override
  List<Object> get props => [];
}

class SignInSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignUpSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class SignOutSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class DeleteUserSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class FollowUserSuccessState extends AuthState {

  final User user;
  const FollowUserSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class LoadUserSuccessState extends AuthState {
  final User user;
  const LoadUserSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class SearchUsersSuccessState extends AuthState {
  final List<User> users;
  const SearchUsersSuccessState({required this.users});

  @override
  List<Object> get props => [users];
}

class UnfollowUserSuccessState extends AuthState {
  final User user;
  const UnfollowUserSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserPhotoSuccessState extends AuthState {
  final User user;
  const UpdateUserPhotoSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}