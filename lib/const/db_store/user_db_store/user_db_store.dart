import 'package:PersonalChat/const/config/config.dart';
import 'package:hive/hive.dart';

class UserDBStore {
  late Box _user;
  UserDBStore() {
    _openCollection();
  }

  void _openCollection() async {
    if (Hive.isBoxOpen(Config.userBoxName)) {
      _user = Hive.box(Config.userBoxName);
    } else {
      _user = await Hive.openBox(Config.userBoxName);
    }
  }

  Future<void> saveUser(Map<String, dynamic> savedValue) async {
    if (savedValue.isNotEmpty) {
      await _user.put(Config.userBoxKey, savedValue);
    }
  }

  Map<dynamic, dynamic>? getUser() {
    return _user.get(Config.userBoxKey);
  }

  Future<void> deleteUser() async {
    await _user.delete(Config.userBoxKey);
  }

  void closeCollection() async {
    Hive.close();
  }
}
