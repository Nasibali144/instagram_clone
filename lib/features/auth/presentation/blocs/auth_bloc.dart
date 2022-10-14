import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/usecase/params/no_params.dart';
import 'package:instagram_clone/core/util/checking.dart';
import 'package:instagram_clone/features/auth/domain/entities/user_entity.dart';
import 'package:instagram_clone/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/follow_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/load_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/follow_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/search_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_in_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/sign_up_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/params/update_user_photo_params.dart';
import 'package:instagram_clone/features/auth/domain/usecases/search_users_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_out_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_up_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/unfollow_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/update_user_photo_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUserUseCase signUpUserUseCase;
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final FollowUserUseCase followUserUseCase;
  final LoadUserUseCase loadUserUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  final UpdateUserPhotoUserUseCase updateUserPhotoUserUseCase;

  /// Todo: Error Handling Manage
  AuthBloc({
    required this.signUpUserUseCase,
    required this.signInUserUseCase,
    required this.signOutUserUseCase,
    required this.deleteUserUseCase,
    required this.updateUserPhotoUserUseCase,
    required this.unfollowUserUseCase,
    required this.searchUsersUseCase,
    required this.loadUserUseCase,
    required this.followUserUseCase,
  }) : super(AuthInitial()) {
    on<SignUpUserEvent>(signUp);
    on<SignInUserEvent>(signIn);
    on<SignOutUserEvent>(signOut);
    on<DeleteUserEvent>(deleteUser);
    on<FollowUserEvent>(followUser);
    on<LoadUserEvent>(loadUser);
    on<SearchUsersEvent>(searchUsers);
    on<UnfollowUserEvent>(unfollowUsers);
    on<UpdateUserPhotoEvent>(updateUserPhoto);
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

  void followUser(FollowUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrFollowUser = await followUserUseCase(FollowParams(user: event.user));
    failureOrFollowUser.fold(
          (failure) => emit(AuthError()),
          (result) => emit(FollowUserSuccessState(user: result)),
    );
  }

  void loadUser(LoadUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrLoadUser = await loadUserUseCase(NoParams());
    failureOrLoadUser.fold(
          (failure) => emit(AuthError()),
          (result) => emit(LoadUserSuccessState(user: result)),
    );
  }

  void searchUsers(SearchUsersEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrSearchUsers = await searchUsersUseCase(SearchParams(keyword: event.keyword));
    failureOrSearchUsers.fold(
          (failure) => emit(AuthError()),
          (result) => emit(SearchUsersSuccessState(users: result)),
    );
  }

  void unfollowUsers(UnfollowUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrUnfollowUser = await unfollowUserUseCase(FollowParams(user: event.user));
    failureOrUnfollowUser.fold(
          (failure) => emit(AuthError()),
          (result) => emit(UnfollowUserSuccessState(user: result)),
    );
  }

  void updateUserPhoto(UpdateUserPhotoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final failureOrUpdateUserPhoto = await updateUserPhotoUserUseCase(UpdateUserPhotoParams(image: event.file));
    failureOrUpdateUserPhoto.fold(
          (failure) => emit(AuthError()),
          (result) => emit(UpdateUserPhotoSuccessState(user: result)),
    );
  }
}
