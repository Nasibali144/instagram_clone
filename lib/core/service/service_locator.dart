import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/core/platform/network_info.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_out_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_up_user_usecase.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> init() async {
  // Bloc
  locator.registerFactory(() => AuthBloc(signUpUserUseCase: locator(), signInUserUseCase: locator(), signOutUserUseCase: locator(), deleteUserUseCase: locator()));

  // Use cases
  locator.registerLazySingleton(() => SignUpUserUseCase(locator()));
  locator.registerLazySingleton(() => SignInUserUseCase(locator()));
  locator.registerLazySingleton(() => SignOutUserUseCase(locator()));
  locator.registerLazySingleton(() => DeleteUserUseCase(locator()));

  // Core
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // Repository
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(fireAuth: locator(), localAuth: locator(), networkInfo: locator()));

  // Data sources
  locator.registerLazySingleton<FireAuthDataSource>(() => FireAuthDataSourceIml(auth: locator()));
  locator.registerLazySingleton<LocalAuthDataSource>(() => LocalAuthDataSourceIml(local: locator()));

  // External
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  locator.registerLazySingleton(() => firebaseAuth);

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  locator.registerLazySingleton(() => DataConnectionChecker());
}
