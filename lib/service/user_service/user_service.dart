import 'package:PersonalChat/const/config/config.dart';
import 'package:PersonalChat/const/db_store/user_db_store/user_db_store.dart';
import 'package:PersonalChat/model/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final db = FirebaseFirestore.instance;
  late UserDBStore dbStore;
  UserService() {
    dbStore = UserDBStore();
  }
  Future<void> createUser(Map<String, dynamic> user) async {
    await db.collection(Config.userCollection).doc(user['userId']).set(user);
  }

  Future<Map<String, dynamic>> getUser(String userId) async {
    final result = await db.collection(Config.userCollection).doc(userId).get();
    final Map<String, dynamic> resultMap = result.data() ?? {};
    return resultMap;
  }
}

class UserLocalService {
  UserDBStore dbStore = UserDBStore();

  UserModel? getUserLocal() {
    final result = dbStore.getUser();
    if (result != null) {
      return UserModel.fromJson(result);
    }
    return null;
  }

  Future<void> deleteUserLocal() async {
    await dbStore.deleteUser();
  }
}
