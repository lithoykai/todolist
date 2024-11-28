import 'package:flutter/material.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/infra/failure/failure.dart';
import 'package:todolist/infra/routers/app_routers.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/auth/controller/auth_controller.dart';
import 'package:todolist/presentation/pages/auth/controller/synchronize_controller.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final controller = getIt<AuthController>();
  final synchronizeController = getIt<SynchronizeController>();

  final _authFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  _onSubmit() async {
    if (_authFormKey.currentState!.validate()) {
      _authFormKey.currentState!.save();
    }
    final request = AuthDTO(
      email: _emailController.text,
      password: _passwordController.text,
    );

    bool hasItem = await synchronizeController.checkItem();

    await controller.authenticate(request).then((value) async {
      if (hasItem) {
        await _showAlertSync();
      } else {
        Navigator.of(context).pushReplacementNamed(AppRouters.HOME);
      }
    }).catchError((error) {
      if (error is AuthFailure) {
        _showError(error.toString());
      }
    });
  }

  Future<void> _showAlertSync() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return ListenableBuilder(
          listenable: synchronizeController,
          builder: (context, child) {
            if (synchronizeController.state is SynchronizeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return AlertDialog(
              title: const Text('Atenção'),
              content: const Text(
                'Você possui dados offline, deseja sincronizar agora?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    synchronizeController.syncLater();
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushReplacementNamed(AppRouters.HOME);
                  },
                  child: const Text('Não'),
                ),
                TextButton(
                  onPressed: () async {
                    await synchronizeController.synchronize();
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushReplacementNamed(AppRouters.HOME);
                  },
                  child: const Text('Sim'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showError(String error) {
    showAdaptiveDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Ocorreu um erro!'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.mediumPadding),
      child: ListenableBuilder(
          listenable: controller,
          builder: (ctx, child) {
            if (controller.state is AuthError) {
              Center(
                child: Text('Ocorreu um erro!'),
              );
            }

            return Form(
              key: _authFormKey,
              child: Column(
                children: [
                  Text(
                    controller.isLogin
                        ? 'Faça seu login'
                        : 'Crie sua conta para sincronizar seus dados!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: ThemeConstants.halfPadding),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(ThemeConstants.padding)),
                        ),
                        hintText: 'E-mail'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                  const SizedBox(height: ThemeConstants.halfPadding),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () => setState(() {
                                  _obscureText = !_obscureText;
                                }),
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(ThemeConstants.padding)),
                        ),
                        hintText: 'Senha'),
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureText,
                    validator: (value) =>
                        value!.isEmpty ? 'Informe uma senha' : null,
                    onFieldSubmitted: (_) {
                      if (controller.isLogin) {
                      } else {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocus);
                      }
                    },
                  ),
                  controller.isLogin
                      ? Container()
                      : Column(
                          children: [
                            const SizedBox(height: ThemeConstants.halfPadding),
                            TextFormField(
                              focusNode: _confirmPasswordFocus,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () => setState(() {
                                            _obscureTextConfirm =
                                                !_obscureTextConfirm;
                                          }),
                                      icon: Icon(_obscureTextConfirm
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            ThemeConstants.padding)),
                                  ),
                                  hintText: 'Confirmar senha'),
                              textInputAction: TextInputAction.done,
                              obscureText: _obscureTextConfirm,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value != _passwordController.text) {
                                  return 'As senhas não conferem';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                if (controller.isLogin) {
                                } else {}
                              },
                            ),
                          ],
                        ),
                  const SizedBox(height: ThemeConstants.halfPadding),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _onSubmit(),
                      child: Text(controller.isLogin ? 'Entrar' : 'Cadastrar',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          )),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.changeAuth(),
                    child: Text(controller.isLogin
                        ? 'Criar uma conta'
                        : 'Já tenho uma conta'),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
