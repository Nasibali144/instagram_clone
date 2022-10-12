import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/core/util/checking.dart';
import 'package:instagram_clone/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_in_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_up_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_out_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_up_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUserUseCase signUpUserUseCase;
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  /// Todo: Error Handling Manage
  AuthBloc({
    required this.signUpUserUseCase,
    required this.signInUserUseCase,
    required this.signOutUserUseCase,
    required this.deleteUserUseCase,
  }) : super(AuthInitial()) {
    on<SignUpUserEvent>(signUp);
    on<SignInUserEvent>(signIn);
    on<SignOutUserEvent>(signOut);
    on<DeleteUserEvent>(deleteUser);
  }

  void signUp(SignUpUserEvent event, Emitter<AuthState> emit) async {
    bool next = true;

    if(event.confirmPassword == event.password) {
      Checking.emailChecking(event.email).fold((failure) {
        next = false;
        emit(AuthError());
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      Checking.passwordChecking(event.password).fold((failure) {
        next = false;
        emit(AuthError());
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      Checking.passwordChecking(event.confirmPassword).fold((failure) {
        next = false;
        emit(AuthError());
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      Checking.nameChecking(event.fullName).fold((failure) {
        next = false;
        emit(AuthError());
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      emit(AuthLoading());
    } else {
      return;
    }

    final failureOrSignUp = await signUpUserUseCase(SignUpParams(fullName: event.fullName, email: event.email, password: event.password, confirmPassword: event.confirmPassword,),);
    failureOrSignUp.fold(
        (failure) => emit(AuthError()),
        (result) => emit(SignUpSuccessState()),
    );
  }

  void signIn(SignInUserEvent event, Emitter<AuthState> emit) async {
    bool next = true;

    Checking.emailChecking(event.email).fold((failure) {
      next = false;
      emit(AuthError());
    }, (result) => next = true);


    if(next) {
      Checking.passwordChecking(event.password).fold((failure) {
        next = false;
        emit(AuthError());
      }, (result) => next = true);
    } else {
      return;
    }

    if(next) {
      emit(AuthLoading());
    } else {
      return;
    }

    final failureOrSignIn = await signInUserUseCase(SignInParams(email: event.email, password: event.password,),);
    failureOrSignIn.fold(
          (failure) => emit(AuthError()),
          (result) => emit(SignInSuccessState()),
    );
  }

  void signOut(SignOutUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrSignOut = await signOutUserUseCase(NoParams());
    failureOrSignOut.fold(
          (failure) => emit(AuthError()),
          (result) => emit(SignOutSuccessState()),
    );
  }

  void deleteUser(DeleteUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrDeleteUser = await deleteUserUseCase(NoParams());
    failureOrDeleteUser.fold(
          (failure) => emit(AuthError()),
          (result) => emit(DeleteUserSuccessState()),
    );
  }
}
