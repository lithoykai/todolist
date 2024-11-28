import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/data/models/auth/auth_dto.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/usecase/auth/create_account.dart';
import 'package:todolist/domain/usecase/auth/get_user.dart';
import 'package:todolist/domain/usecase/auth/login.dart';
import 'package:todolist/domain/usecase/auth/logout.dart';
import 'package:todolist/infra/failure/failure.dart';

@lazySingleton
class AuthController extends ChangeNotifier {
  final CreateAccountUseCase _createAccountUseCase;
  final LoginUseCase _loginUseCase;
  final GetUserUseCase _getUserUseCase;
  final LogoutUsecase _logoutUsecase;

  AuthController(
      {required CreateAccountUseCase createAccountUseCase,
      required LoginUseCase loginUseCase,
      required GetUserUseCase getUserUseCase,
      required LogoutUsecase logoutUsecase})
      : _createAccountUseCase = createAccountUseCase,
        _loginUseCase = loginUseCase,
        _getUserUseCase = getUserUseCase,
        _logoutUsecase = logoutUsecase;

  bool isLogin = true;

  String? _token;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  String? _userId;
  UserEntity? user;

  bool isAuth = false;

  AuthState state = AuthIdle();

  void startLoading() {
    state = AuthLoading();
    notifyListeners();
  }

  void endLoading() {
    state = AuthIdle();
    notifyListeners();
  }

  void changeAuth() {
    isLogin = !isLogin;
    notifyListeners();
  }

  Future<void> getUser() async {
    if (user != null) {
      return;
    }
    startLoading();
    if (_token != null && _expiryDate != null) {
      final response = await _getUserUseCase.call();
      return response.fold((l) {
        state = AuthError('Erro ao tentar buscar usuário');
        throw Exception('Erro ao tentar buscar usuário');
      }, (r) {
        user = r;
      });
    }
    endLoading();
  }

  void saveAuthenticate(UserEntity user) {
    _token = user.token;
    _userId = user.id;
    _expiryDate = user.expiryDate;
    user = user;
    notifyListeners();
  }

  void updateAuthStatus(bool value) {
    isAuth = value;
    notifyListeners();
  }

  Future<UserEntity> authenticate(AuthDTO request) async {
    state = AuthLoading();
    var auth;
    if (isLogin) {
      auth = await _loginUseCase.call(request);
    } else {
      auth = await _createAccountUseCase.call(request);
    }

    return auth.fold((failure) {
      if (failure is AuthFailure) {
        state = AuthError(failure.msg!);
        throw AuthFailure(msg: failure.msg!);
      } else if (failure is AppFailure) {
        state = AuthError(failure.msg!);
        throw Future.error(failure.msg!);
      } else {
        throw Exception('Erro desconhecido');
      }
    }, (response) {
      saveAuthenticate(response);
      final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
      updateAuthStatus(_token != null && isValid);

      return response;
    });
  }

  Future<void> logout() async {
    final response = await _logoutUsecase();
    response.fold((failure) {
      state = AuthError('Erro ao tentar fazer logout');
    }, (response) {
      _token = null;
      _userId = null;
      _expiryDate = null;
      user = null;
      clearLogoutTimer();
      updateAuthStatus(false);
      notifyListeners();
    });
  }

  void clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    // if (isAuth) return;
    final user = await _getUserUseCase.call();
    UserEntity? currentUser;
    user.fold((l) {}, (r) {
      currentUser = r;
    });
    if (currentUser == null) return;

    if (currentUser!.expiryDate.isBefore(DateTime.now())) return;

    _token = currentUser!.token;
    _userId = currentUser!.id;
    _expiryDate = currentUser!.expiryDate;

    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    updateAuthStatus(_token != null && isValid);
    notifyListeners();
  }
}

abstract class AuthState {}

class AuthIdle implements AuthState {}

class AuthLoading implements AuthState {}

class AuthError implements AuthState {
  final String message;

  AuthError(this.message);
}
