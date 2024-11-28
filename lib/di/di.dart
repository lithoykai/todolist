import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/datasource/task/task_datasource.dart';
import 'package:todolist/data/datasource/task/task_datasource_offline.dart';
import 'package:todolist/data/datasource/task/task_datasource_proxy.dart';
import 'package:todolist/data/datasource/task/task_remote_datasource.dart';
import 'package:todolist/data/repositories/task_repository_impl.dart';
import 'package:todolist/domain/entities/task_entity.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/task/task_repository.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void setup() {}
Future<void> init() async {
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(UserEntityAdapter());
  Hive.registerAdapter(PriorityStatusAdapter());
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  var hiveData = Directory('${directory.path}/db');
  await Hive.initFlutter(hiveData.path);

  getIt.registerFactory<TaskDatasourceOffline>(
      () => TaskDatasourceOffline(hiveService: getIt<HiveService>()));

  getIt.registerFactory<TaskRemoteDatasource>(() => TaskRemoteDatasource(
      hive: getIt<HiveService>(), http: getIt<HttpService>()));

  getIt.registerLazySingleton<TaskDataSourceProxy>(
    () => TaskDataSourceProxy(dataSource: getIt<TaskDatasourceOffline>()),
  );

  getIt.registerFactory<ITaskDataSource>(
    () => getIt<TaskDataSourceProxy>(),
  );

  getIt.registerFactory<ITaskRepository>(
    () => TaskRepositoryImpl(taskDataSource: getIt<TaskDataSourceProxy>()),
  );
  getIt.allowReassignment = true;

  $initGetIt(getIt);
}
