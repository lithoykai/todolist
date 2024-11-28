import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:todolist/domain/usecase/synchronize/has_item.dart';
import 'package:todolist/domain/usecase/synchronize/synchronize_usecase.dart';

@lazySingleton
class SynchronizeController extends ChangeNotifier {
  final HasItemUseCase _hasItemUseCase;
  final SynchronizeUsecase _synchronizeUsecase;

  SynchronizeController(
      {required HasItemUseCase hasItemUseCase,
      required SynchronizeUsecase synchronizeUsecase})
      : _hasItemUseCase = hasItemUseCase,
        _synchronizeUsecase = synchronizeUsecase;

  bool hasItem = false;
  SynchronizeState state = SynchronizeIdle();

  Future<bool> checkItem() async {
    final response = await _hasItemUseCase.call();
    return response.fold((l) {
      throw Exception('Erro ao tentar verificar tarefas');
    }, (r) {
      return r;
    });
  }

  void syncLater() {
    hasItem = true;
    notifyListeners();
  }

  Future<void> synchronize() async {
    state = SynchronizeLoading();
    final response = await _synchronizeUsecase.call();
    response.fold((l) async {
      hasItem = await checkItem();

      state = SynchronizeStateError('Erro ao tentar sincronizar tarefas');
      notifyListeners();
    }, (r) {
      hasItem = false;
      state = SynchronizeIdle();
      notifyListeners();
    });
  }
}

class SynchronizeState {}

class SynchronizeIdle extends SynchronizeState {}

class SynchronizeLoading extends SynchronizeState {}

class SynchronizeStateError extends SynchronizeState {
  final String message;

  SynchronizeStateError(this.message);
}
