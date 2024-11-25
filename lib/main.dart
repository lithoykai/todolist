import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  // await di.init();
}
