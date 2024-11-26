import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart' as di;
import 'package:todolist/presentation/app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const AppWidget());
}
