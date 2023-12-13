import 'package:PersonalChat/model/user_model/user_model.dart';

class LocalData {
  static LocalData? _instance;
  factory LocalData() => _instance ??= new LocalData._();
  LocalData._();
  UserModel? userModel;
}
