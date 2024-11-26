import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class HiveService {
  final HiveInterface _hive;

  HiveService({required HiveInterface hive}) : _hive = hive;

  Future<Box> _openBox(String boxName) async {
    if (!_hive.isBoxOpen(boxName)) {
      return await _hive.openBox(boxName);
    }
    return _hive.box(boxName);
  }

  Future<void> saveItem(String boxName, dynamic key, var item) async {
    final box = await _openBox(boxName);
    try {
      await box.put(key, item);
    } catch (e) {
      throw HiveError("Erro ao salvar item: $e");
    }
  }

  Future<T?> getItem<T>(String boxName, dynamic key) async {
    final box = await _openBox(boxName);
    try {
      if (box.containsKey(key)) {
        return box.get(key) as T?;
      }
      return null;
    } catch (e) {
      throw HiveError("Erro ao obter item: $e");
    }
  }

  Future<List<T>> getAllItems<T>(String boxName) async {
    final box = await _openBox(boxName);
    try {
      return box.values.cast<T>().toList();
    } catch (e) {
      throw HiveError("Erro ao obter todos os itens: $e");
    }
  }

  Future<bool> deleteItem(String boxName, dynamic key) async {
    final box = await _openBox(boxName);
    try {
      if (box.containsKey(key)) {
        await box.delete(key);
        return true;
      }
      return false;
    } catch (e) {
      throw HiveError("Erro ao deletar item: $e");
    }
  }

  Future<T> updateItem<T>(String boxName, dynamic key, T updatedItem) async {
    final box = await _openBox(boxName);
    try {
      await box.put(key, updatedItem);
      return updatedItem;
    } catch (e) {
      throw HiveError("Erro ao atualizar item: $e");
    }
  }
}
