import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zapxx/model/user/auth_model.dart';
import 'package:zapxx/model/user/user_model.dart';

class SessionController {
  // Singleton instance
  static final SessionController _session = SessionController._internal();

  factory SessionController() {
    return _session;
  }

  SessionController._internal() {
    isLogin = false;
  }

  bool? isLogin;
  UserModel user = UserModel();
  AuthModelResponse authModel = AuthModelResponse(
    message: '',
    response: ResponseData(
      token: '',
      user: User(id: 0, role: '', email: '', name: ''),
    ),
  );
  static const String boolKey1 = 'bio';
  static const String boolKey2 = 'schedule';
  static const String boolKey3 = 'portfolio';
  static const String boolKey4 = 'bank';

  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> saveSellerId(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int> getSellerId(String key, {int defaultValue = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }

  // Save AuthModelResponse data into SharedPreferences
  Future<void> saveAuthModelInPreference(AuthModelResponse authModel) async {
    final prefs = await SharedPreferences.getInstance();
    final authModelJson = jsonEncode(authModel.toJson());
    print('Saving auth model: $authModelJson');
    await prefs.setString('authModel', authModelJson);
    await prefs.setBool('isLogin', true); // Set login status
    print('Auth model saved');
  }

  // Retrieve AuthModelResponse data from SharedPreferences
  Future<void> getAuthModelFromPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authModelData = prefs.getString('authModel') ?? '';
      final isLoggedIn = prefs.getBool('isLogin') ?? false;
      print('Retrieved auth model: $authModelData');

      if (authModelData.isNotEmpty) {
        authModel = AuthModelResponse.fromJson(jsonDecode(authModelData));
      }
      isLogin = isLoggedIn;
    } catch (e) {
      debugPrint('Error retrieving auth model: $e');
    }
  }

  // Save UserModel data into SharedPreferences
  Future<void> saveUserInPreference(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
    await prefs.setBool('isLogin', true); // Set login status
    print('User saved: $userJson');
  }

  // Retrieve UserModel data from SharedPreferences
  Future<void> getUserFromPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user') ?? '';
      final isLoggedIn = prefs.getBool('isLogin') ?? false;

      if (userData.isNotEmpty) {
        user = UserModel.fromJson(jsonDecode(userData));
      }
      isLogin = isLoggedIn;
    } catch (e) {
      debugPrint('Error retrieving user: $e');
    }
  }

  // Logout: Clear all stored data in SharedPreferences
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authModel');
      await prefs.remove('user');
      await prefs.remove('isLogin');
      await prefs.remove('bio');
      await prefs.remove('schedule');
      await prefs.remove('portfolio');
      await prefs.remove('bank');

      // Reset session state
      isLogin = false;
      user = UserModel();
      authModel = AuthModelResponse(
        message: '',
        response: ResponseData(
          token: '',
          user: User(id: 0, role: '', email: '', name: ''),
        ),
      );
      print('Logout successful ');
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
