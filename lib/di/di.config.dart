// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;

import '../data/datasource/clients/hive/hive_service.dart' as _i231;
import '../data/datasource/clients/http/http_service.dart' as _i595;
import '../data/datasource/clients/third_modules.dart' as _i1070;
import '../data/datasource/task/task_datasource_impl.dart' as _i810;
import '../data/datasource/task/task_datasource_offline.dart' as _i219;
import '../data/datasource/user/auth_remote_datasource.dart' as _i611;
import '../data/datasource/user/auth_remote_datasource_impl.dart' as _i118;
import '../data/repositories/auth_repository_impl.dart' as _i74;
import '../data/repositories/task_repository_impl.dart' as _i114;
import '../domain/repositories/task/task_repository.dart' as _i1068;
import '../domain/repositories/user/auth_repository.dart' as _i58;
import '../domain/usecase/auth/create_account.dart' as _i925;
import '../domain/usecase/auth/get_user.dart' as _i995;
import '../domain/usecase/auth/login.dart' as _i1062;
import '../domain/usecase/task/create_task.dart' as _i509;
import '../domain/usecase/task/delete_task.dart' as _i926;
import '../domain/usecase/task/get_tasks.dart' as _i678;
import '../domain/usecase/task/update_task.dart' as _i255;
import '../presentation/pages/auth/controller/auth_controller.dart' as _i873;
import '../presentation/pages/controller/task_controller.dart' as _i743;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i361.Dio>(() => registerModule.dio());
  gh.factory<_i979.HiveInterface>(() => registerModule.hive());
  gh.lazySingleton<_i873.AuthController>(() => _i873.AuthController());
  gh.factory<_i231.HiveService>(
      () => _i231.HiveService(hive: gh<_i979.HiveInterface>()));
  gh.factory<_i219.ITaskDataSource>(
      () => _i810.TaskDataSourceImpl(hiveService: gh<_i231.HiveService>()));
  gh.factory<_i595.HttpService>(() => _i595.HttpService(
        dio: gh<_i361.Dio>(),
        hiveService: gh<_i231.HiveService>(),
      ));
  gh.factory<_i1068.ITaskRepository>(() =>
      _i114.TaskRepositoryImpl(taskDataSource: gh<_i219.ITaskDataSource>()));
  gh.factory<_i509.CreateTaskUseCase>(
      () => _i509.CreateTaskUseCase(repository: gh<_i1068.ITaskRepository>()));
  gh.factory<_i255.UpdateTaskUseCase>(
      () => _i255.UpdateTaskUseCase(repository: gh<_i1068.ITaskRepository>()));
  gh.factory<_i678.GetTasksUseCase>(
      () => _i678.GetTasksUseCase(repository: gh<_i1068.ITaskRepository>()));
  gh.factory<_i926.DeleteTaskUseCase>(
      () => _i926.DeleteTaskUseCase(gh<_i1068.ITaskRepository>()));
  gh.singleton<_i743.TaskController>(() => _i743.TaskController(
        getTasksUseCase: gh<_i678.GetTasksUseCase>(),
        createTaskUseCase: gh<_i509.CreateTaskUseCase>(),
        deleteTaskUseCase: gh<_i926.DeleteTaskUseCase>(),
        updateTaskUseCase: gh<_i255.UpdateTaskUseCase>(),
      ));
  gh.factory<_i611.AuthRemoteDatasource>(() => _i118.AuthRemoteDatasourceImpl(
        http: gh<_i595.HttpService>(),
        hive: gh<_i231.HiveService>(),
      ));
  gh.factory<_i58.AuthRepository>(() =>
      _i74.AuthRepositoryImpl(datasource: gh<_i611.AuthRemoteDatasource>()));
  gh.factory<_i1062.LoginUseCase>(
      () => _i1062.LoginUseCase(gh<_i58.AuthRepository>()));
  gh.factory<_i925.CreateAccountUseCase>(() =>
      _i925.CreateAccountUseCase(authRepository: gh<_i58.AuthRepository>()));
  gh.factory<_i995.GetUserUseCase>(
      () => _i995.GetUserUseCase(authRepository: gh<_i58.AuthRepository>()));
  return getIt;
}

class _$RegisterModule extends _i1070.RegisterModule {}
