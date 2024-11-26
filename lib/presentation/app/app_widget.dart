import 'package:flutter/material.dart';
import 'package:todolist/infra/routers/app_routers.dart';
import 'package:todolist/presentation/pages/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      routes: {
        AppRouters.HOME: (context) => const HomePage(),
      },
    );
  }
}
