import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:todolist/domain/entities/task_entity.dart';

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
  Hive.registerAdapter(PriorityStatusAdapter());
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  var hiveData = Directory('${directory.path}/db');
  await Hive.initFlutter(hiveData.path);

  $initGetIt(getIt);
}
