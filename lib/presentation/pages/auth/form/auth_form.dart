import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist/di/di.dart';
import 'package:todolist/infra/theme/theme_constants.dart';
import 'package:todolist/presentation/pages/auth/controller/auth_controller.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final controller = getIt<AuthController>();

  final _authFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

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

    try {} catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.mediumPadding),
      child: ListenableBuilder(
          listenable: controller,
          builder: (ctx, child) {
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      print(_emailController.text);
                      if (_authFormKey.currentState!.validate()) {
                        if (controller.isLogin) {
                        } else {}
                      }
                    },
                    child: Text(controller.isLogin ? 'Entrar' : 'Cadastrar',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        )),
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
