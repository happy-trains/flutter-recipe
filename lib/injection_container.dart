import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typesense/typesense.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/search_recipe/data/datasources/recipes_local_data_source.dart';
import 'features/search_recipe/data/datasources/recipes_remote_data_source.dart';
import 'features/search_recipe/data/repositories/recipes_repository_impl.dart';
import 'features/search_recipe/domain/repositories/recipes_repository.dart';
import 'features/search_recipe/domain/usecases/get_index_size.dart' as use_case;
import 'features/search_recipe/domain/usecases/search_recipes.dart' as use_case;
import 'features/search_recipe/presentation/bloc/search_recipe_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _initFeatures();

  _initCore();

  await _initExternal();
}

_initFeatures() {
  //! Bloc
  sl.registerFactory(
    () => SearchRecipeBloc(
      getIndexSizeUseCase: sl(),
      searchRecipesUseCase: sl(),
      inputConverter: sl(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton(() => use_case.GetIndexSize(sl()));
  sl.registerLazySingleton(() => use_case.SearchRecipes(sl()));

  //! Repository
  sl.registerLazySingleton<RecipesRepository>(
    () => RecipesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //! Data sources
  sl.registerLazySingleton<RecipesRemoteDataSource>(
      () => RecipesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RecipesLocalDataSource>(
      () => RecipesLocalDataSourceImpl(sl()));
}

_initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

_initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  final config = Configuration(
    const String.fromEnvironment('apiKey'),
    nodes: {
      Node.withUri(Uri.parse(const String.fromEnvironment('hostAddress')))
    },
    numRetries: 3,
    cachedSearchResultsTTL: Duration(seconds: 60),
  );
  sl.registerLazySingleton(() => Client(config));

  sl.registerLazySingleton(() => InternetConnectionChecker());
}
