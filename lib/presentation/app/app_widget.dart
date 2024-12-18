import 'package:flutter/material.dart';
import 'package:todolist/infra/routers/app_routers.dart';
import 'package:todolist/infra/theme/theme_app.dart';
import 'package:todolist/presentation/auth_or_home.dart';
import 'package:todolist/presentation/pages/auth/auth_page.dart';
import 'package:todolist/presentation/pages/home_page.dart';
import 'package:todolist/presentation/pages/task/task_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeApp.lightTheme,
      routes: {
        AppRouters.AUTH_OR_HOME: (context) => const AuthOrHome(),
        AppRouters.HOME: (context) => const HomePage(),
        AppRouters.TASKDETAIL: (context) => TaskPage(),
        AppRouters.AUTHPAGE: (context) => const AuthPage(),
      },
    );
  }
}
