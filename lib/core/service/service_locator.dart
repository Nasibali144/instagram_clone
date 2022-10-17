import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:instagram_clone/core/datasources/cloud_storage_data_source.dart';
import 'package:instagram_clone/core/datasources/notification_data_source.dart';
import 'package:instagram_clone/core/platform/network_info.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/fire_store_user_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/local_auth_data_source.dart';
import 'package:instagram_clone/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/follow_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/load_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/search_users_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_in_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_out_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/sign_up_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/unfollow_user_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/update_user_photo_usecase.dart';
import 'package:instagram_clone/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:instagram_clone/features/post/data/datasources/fire_store_post_data_source.dart';
import 'package:instagram_clone/features/post/data/repositories/post_repository_impl.dart';
import 'package:instagram_clone/features/post/domain/repositories/post_repository.dart';
import 'package:instagram_clone/features/post/domain/usecases/like_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_feeds_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_likes_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/load_posts_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/remove_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/store_post_usecase.dart';
import 'package:instagram_clone/features/post/presentation/blocs/post_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> init() async {

  // auth bloc
  locator.registerFactory(() => AuthBloc(
        signUpUserUseCase: locator(),
        signInUserUseCase: locator(),
        signOutUserUseCase: locator(),
        deleteUserUseCase: locator(),
        updateUserPhotoUserUseCase: locator(),
        unfollowUserUseCase: locator(),
        searchUsersUseCase: locator(),
        loadUserUseCase: locator(),
        followUserUseCase: locator(),
      ));

  // post bloc
  locator.registerFactory(() => PostBloc(
    likePostUseCase: locator(),
    loadFeedsUseCase: locator(),
    loadLikesUseCase: locator(),
    loadPostsUseCase: locator(),
    removePostUseCase: locator(),
    storePostUseCase: locator(),
  ));

  // Use cases
  // auth
  locator.registerLazySingleton(() => SignUpUserUseCase(locator()));
  locator.registerLazySingleton(() => SignInUserUseCase(locator()));
  locator.registerLazySingleton(() => SignOutUserUseCase(locator()));
  locator.registerLazySingleton(() => DeleteUserUseCase(locator()));
  locator.registerLazySingleton(() => FollowUserUseCase(locator()));
  locator.registerLazySingleton(() => LoadUserUseCase(locator()));
  locator.registerLazySingleton(() => SearchUsersUseCase(locator()));
  locator.registerLazySingleton(() => UnfollowUserUseCase(locator()));
  locator.registerLazySingleton(() => UpdateUserPhotoUserUseCase(locator()));

  // post
  locator.registerLazySingleton(() => LikePostUseCase(locator()));
  locator.registerLazySingleton(() => LoadFeedsUseCase(locator()));
  locator.registerLazySingleton(() => LoadLikesUseCase(locator()));
  locator.registerLazySingleton(() => LoadPostsUseCase(locator()));
  locator.registerLazySingleton(() => RemovePostUseCase(locator()));
  locator.registerLazySingleton(() => StorePostUseCase(locator()));


  // Core
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // Repository
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      fireAuth: locator(),
      localAuth: locator(),
      networkInfo: locator(),
      fireStore: locator(),
      cloudStorage: locator(),
      fireStorePost: locator()));

  locator.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(fireStorePost: locator(), cloudStorage: locator(), localAuth: locator(), networkInfo: locator(), fireStoreUser: locator()));


  // Data sources
  locator.registerLazySingleton<FireAuthDataSource>(
      () => FireAuthDataSourceIml(auth: locator()));
  locator.registerLazySingleton<LocalAuthDataSource>(
      () => LocalAuthDataSourceIml(local: locator()));
  locator.registerLazySingleton<FireStoreUserDataSource>(
      () => FireStoreUserDataSourceImpl(fireStore: locator()));
  locator.registerLazySingleton<FireStorePostDataSource>(
      () => FireStorePostDataSourceImpl(fireStore: locator()));
  locator.registerLazySingleton<CloudStorageDataSource>(
      () => CloudStorageDataSourceImpl(cloud: locator()));
  locator.registerLazySingleton<NotificationDataSource>(
      () => NotificationDataSourceImpl(client: locator()));

  // External
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  locator.registerLazySingleton(() => firebaseAuth);

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  locator.registerLazySingleton(() => firebaseFirestore);

  final Reference cloudStorage = FirebaseStorage.instance.ref();
  locator.registerLazySingleton(() => cloudStorage);

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  locator.registerLazySingleton(() => Client());

  locator.registerLazySingleton(() => DataConnectionChecker());
}
