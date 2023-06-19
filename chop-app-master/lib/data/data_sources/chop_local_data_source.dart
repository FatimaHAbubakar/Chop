import 'dart:convert';

import 'package:chop/core/failure/error.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/model/user.dart';

abstract class ChopLocalDataSource {
  String? getToken();
  void setToken(String token);
  User? getUser();
  void setUser(User user);
  void clearToken();
  void clearUser();
}

class ChopLocalDataSourceImpl extends ChopLocalDataSource {
  final box = Hive.box('chopBox');
  final SharedPreferences prefs;

  ChopLocalDataSourceImpl(this.prefs);

  @override
  String? getToken() {
    try {
      return box.get('token');
    } on Exception {
      throw CacheException();
    }
  }

  @override
  void setToken(String token) {
    try {
      box.put('token', token);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  User? getUser() {
    try {
      return User.fromJson(jsonDecode(prefs.getString('user')!));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  void setUser(User user) {
    try {
      prefs.setString('user', jsonEncode(user.toJson()));
    } on Exception {
      throw CacheException();
    }
  }

  @override
  void clearToken() {
    box.clear();
  }

  @override
  void clearUser() {
    prefs.clear();
  }
}
