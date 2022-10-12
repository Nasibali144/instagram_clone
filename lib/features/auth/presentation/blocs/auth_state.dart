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