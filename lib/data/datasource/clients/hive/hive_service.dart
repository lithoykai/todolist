import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class HiveService {
  HiveInterface _hive;

  HiveService({required HiveInterface hive}) : _hive = hive;

  Future<Box> _openBox(String boxName) async {
    if (!_hive.isBoxOpen(boxName)) {
      return await _hive.openBox(boxName);
    }
    return _hive.box(boxName);
  }

  Future<void> saveItem(String boxName, var item) async {
    final box = await _openBox(boxName);
    try {
      await box.add(item);
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

  Future<void> deleteItem(String boxName, dynamic key) async {
    final box = await _openBox(boxName);
    try {
      if (box.containsKey(key)) {
        await box.delete(key);
      }
    } catch (e) {
      throw HiveError("Erro ao deletar item: $e");
    }
  }

  Future<void> updateItem<T>(String boxName, dynamic key, T updatedItem) async {
    final box = await _openBox(boxName);
    try {
      if (box.containsKey(key)) {
        await box.put(key, updatedItem);
      } else {
        throw HiveError("Item não encontrado para atualização.");
      }
    } catch (e) {
      throw HiveError("Erro ao atualizar item: $e");
    }
  }
}
