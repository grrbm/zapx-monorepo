import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zapxx/model/user/auth_model.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import '../../repository/auth_api/auth_repository.dart';

class SignupViewModel with ChangeNotifier {
  AuthRepository authRepository;
  SignupViewModel({required this.authRepository});

  bool _signupLoading = false;
  bool get signupLoading => _signupLoading;

  setSignupLoading(bool value) {
    _signupLoading = value;
    notifyListeners();
  }

  //creating getter method to store value of input email
  String _email = '';
  String get email => _email;

  setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  //creating getter method to store value of input password
  String _password = '';
  String get password => _password;

  setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;

  setConfirmPassword(String password) {
    _confirmPassword = password;
    notifyListeners();
  }

  //creating getter method to store value of input username
  String _username = '';
  String get username => _username;

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  //creating getter method to store value of input role
  String _role = 'CONSUMER';
  String get role => _role;

  setRole(String role) {
    _role = role;
    notifyListeners();
  }

// Add a boolean property to store the "Are you Photographer" value
  bool _areYouPhotographer = false;
  bool get areYouPhotographer => _areYouPhotographer;

  setAreYouPhotographer(bool value) {
    _areYouPhotographer = value;
    _role =
        value ? 'SELLER' : 'CONSUMER'; // Set role based on the boolean value
    notifyListeners();
  }

  Future<AuthModelResponse> signupApi(dynamic data) async {
    try {
      setSignupLoading(true);
      final response = await authRepository.signupApi(data);
      await SessionController().saveAuthModelInPreference(response);
      await SessionController().getAuthModelFromPreference();
      setSignupLoading(false);

      return response;
    } catch (e) {
      setSignupLoading(false);
      throw Exception(e);
    }
  }
}
