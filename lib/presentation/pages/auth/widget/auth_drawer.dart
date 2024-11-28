import 'package:flutter/material.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/infra/routers/app_routers.dart';
import 'package:todolist/presentation/pages/auth/controller/auth_controller.dart';
import 'package:todolist/presentation/pages/auth/controller/synchronize_controller.dart';
import 'package:todolist/presentation/pages/controller/task_controller.dart';

class AuthDrawerWidget extends StatefulWidget {
  const AuthDrawerWidget({super.key});

  @override
  State<AuthDrawerWidget> createState() => _AuthDrawerWidgetState();
}

class _AuthDrawerWidgetState extends State<AuthDrawerWidget> {
  final controller = getIt<AuthController>();
  final taskController = getIt<TaskController>();
  final syncController = getIt<SynchronizeController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  _init() async {
    setState(() {
      isLoading = true;
    });
    await controller.getUser().then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            if (controller.state is AuthError) {
              return const Center(
                child: Text('Ocorreu um erro!'),
              );
            }

            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      controller.isAuth
                          ? Column(
                              children: [
                                UserAccountsDrawerHeader(
                                  accountName: Text("Olá! Bem vindo"),
                                  accountEmail: Text(controller.user?.email ??
                                      'email@email.com'),
                                ),
                                ListenableBuilder(
                                    listenable: syncController,
                                    builder: (context, child) {
                                      return syncController.hasItem
                                          ? ListTile(
                                              title: const Text('Sincronizar'),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Atenção'),
                                                      content: const Text(
                                                          'Você possui dados offline, deseja sincronizar agora?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child:
                                                              const Text('Não'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async => await syncController
                                                              .synchronize()
                                                              .then((value) => Navigator
                                                                      .of(
                                                                          context)
                                                                  .pushReplacementNamed(
                                                                      AppRouters
                                                                          .HOME)),
                                                          child:
                                                              const Text('Sim'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : Container();
                                    }),
                                ListTile(
                                  title: const Text('Sair'),
                                  onTap: () =>
                                      controller.logout().then((value) {
                                    taskController.getTasks();
                                  }),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                DrawerHeader(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.13,
                                          child: Image.asset(
                                              'assets/images/auth.png')),
                                      const Text(
                                          'Faça login e sincronize seus dados!'),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Login'),
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(AppRouters.AUTHPAGE),
                                ),
                              ],
                            )
                    ],
                  );
          }),
    );
  }
}
