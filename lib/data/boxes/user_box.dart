import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/user_model.dart';

class UserBox {
  static const String boxName = 'user';
  late Box<UserModel> _box;
  late UserModel _userModel;

  ValueListenable<Box<UserModel>> listenable() => _box.listenable();

  Future<void> init() async {
    _box = Hive.box<UserModel>(boxName);
    _userModel = _box.get(0) ?? UserModel(onboardingStatus: false);
    await _box.put(0, _userModel);
  }

  bool getBoardingStatus() {
    return _userModel.onboardingStatus;
  }

  Future<void> updateUser({String? name}) async {
    if (name != null && name.isEmpty) return;
    _userModel.name = name;
    _box.put(0, _userModel);
  }

  UserModel getUser() {
    return _userModel;
  }
}