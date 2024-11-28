import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/presentation/pages/auth/auth_page.dart';
import 'package:todolist/presentation/pages/auth/controller/auth_controller.dart';
import 'package:todolist/presentation/pages/home_page.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = getIt<AuthController>();

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return ListenableBuilder(
              listenable: auth,
              builder: (context, child) {
                return auth.isAuth ? const HomePage() : const AuthPage();
              });
        }
      },
    );
  }
}
