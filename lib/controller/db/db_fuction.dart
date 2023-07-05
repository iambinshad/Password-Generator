import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:methodchannelprojects/model/password_history_model.dart';

class DbClass with ChangeNotifier {
  List<PasswordModel> historList = [];

   clearDatabase() async {
    final passwordDb = await Hive.openBox<PasswordModel>('password_Database');
    await passwordDb.clear();
    getAllPasswords();
  }

  void addPasswordHistory(PasswordModel data) async {
    final passwordDb = await Hive.openBox<PasswordModel>('password_Database');
    final id = await passwordDb.add(data);
    data.id = id;
    final value = PasswordModel(password: data.password, time: data.time,id: id);
    passwordDb.put(id, value);
    historList.add(data);
    notifyListeners();
  }

  Future<void> getAllPasswords() async {
    final passwordDb = await Hive.openBox<PasswordModel>('password_Database');
    historList.clear();
    historList.addAll(passwordDb.values);
    notifyListeners();
  }

   deletePassword(int id) async {
    final passwordDb = await Hive.openBox<PasswordModel>('password_Database');
    await passwordDb.delete(id);
    getAllPasswords();
  }
}
