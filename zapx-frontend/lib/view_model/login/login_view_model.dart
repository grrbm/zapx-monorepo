import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

import '../../repository/auth_api/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  AuthRepository authRepository;
  LoginViewModel({required this.authRepository});

  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;

  setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  //creating getter method to store value of input email
  String _email = '';
  String get email => _email;

  setEmail(String email) {
    _email = email;
  }

  //creating getter method to store value of input password
  String _password = '';
  String get password => _password;

  setPassword(String password) {
    _password = password;
  }

  Future loginApi(dynamic data) async {
    try {
      setLoginLoading(true);
      final response = await authRepository.loginApi(data);
      await SessionController().saveAuthModelInPreference(response);
      await SessionController().getAuthModelFromPreference();
      setLoginLoading(false);

      return response;
    } catch (e) {
      setLoginLoading(false);
      throw Exception(e);
    }
  }
}
