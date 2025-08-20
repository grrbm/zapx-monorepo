import 'package:flutter/material.dart';
import 'package:zapxx/model/user/auth_model.dart';
import 'package:zapxx/model/user/consumer_model.dart';
import 'package:zapxx/repository/auth_api/auth_http_api_repository.dart';
import 'package:zapxx/repository/auth_api/auth_repository.dart';
import 'package:zapxx/repository/home_api/home_http_api_repository.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer_model.dart';
import 'package:zapxx/model/user/seller_model.dart';

class UserViewModel with ChangeNotifier {
  final AuthRepository authRepository;
  UserViewModel({required this.authRepository}) {
    // Initialize data from session when the provider is created
    loadUserFromSession();
  }
  UserConsumer? _userConsumer;
  SavedPhotographerModel? _savedSeller;
  UserResponse? _seller;

  UserConsumer? get userConsumer => _userConsumer;
  SavedPhotographerModel? get savedSeller => _savedSeller;
  UserResponse? get seller => _seller;

  void setUserConsumer(UserConsumer userConsumer) {
    _userConsumer = userConsumer;
    notifyListeners();
  }

  void setSavedSeller(SavedPhotographerModel savedSeller) {
    _savedSeller = savedSeller;
    notifyListeners();
  }

  // Loading states
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // User data stored after login/signup
  AuthModelResponse? _authModel;
  AuthModelResponse? get authModel => _authModel;

  // Form Field Data Management
  String _email = '';
  String get email => _email;

  setEmail(String email) {
    _email = email;
    notifyListeners();
  }

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

  String _username = '';
  String get username => _username;

  setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  String _role = 'CONSUMER';
  String get role => _role;

  setRole(String role) {
    _role = role;
    notifyListeners();
  }

  bool _areYouPhotographer = false;
  bool get areYouPhotographer => _areYouPhotographer;

  setAreYouPhotographer(bool value) {
    _areYouPhotographer = value;
    _role = value ? 'SELLER' : 'CONSUMER'; // Adjust role based on the boolean
    notifyListeners();
  }

  // Login Functionality
  Future<AuthModelResponse> loginUser(dynamic data) async {
    try {
      setLoading(true);
      final response = await authRepository.loginApi(data);

      // Save user data in session
      _authModel = response;

      await SessionController().saveAuthModelInPreference(response);
      await SessionController().getAuthModelFromPreference();
      print(
        'Session auth object ${SessionController().authModel.response.token}',
      );
      print('Yes auth ${_authModel!.response.token}');
      _authModel = SessionController().authModel;
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('Login Failed: $e');
    }
  }

  // Forgot Functionality
  Future<Map<String, dynamic>> forgotpassword(dynamic data) async {
    try {
      setLoading(true);
      final response = await AuthHttpApiRepository().forgotPassword(data);
      // Save user data in session
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('Login Failed: $e');
    }
  }

  //update profile
  Future<Map<String, dynamic>> updateProfile(dynamic data) async {
    try {
      setLoading(true);
      final response = await AuthHttpApiRepository().updateProfile(
        data,
        headers: {'Authorization': authModel!.response.token},
      );
      // Save user data in session
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('update Failed: $e');
    }
  }

  //discount seller
  Future<Map<String, dynamic>> discountSeller(dynamic data) async {
    try {
      setLoading(true);
      final response = await AuthHttpApiRepository().discountSeller(
        data,
        headers: {'Authorization': authModel!.response.token},
      );
      // Save user data in session
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('update Failed: $e');
    }
  }

  //update seller profile
  Future<Map<String, dynamic>> updateSellerProfile(dynamic data) async {
    try {
      setLoading(true);
      final response = await AuthHttpApiRepository().updateSeller(
        data,
        headers: {'Authorization': authModel!.response.token},
      );
      setLoading(false);
      await fetchSeller(); // Fetch latest seller data after update
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('update Failed: $e');
    }
  }

  // verifyOtp Functionality
  Future<Map<String, dynamic>> verifyOtp(dynamic data) async {
    try {
      setLoading(true);
      final response = await AuthHttpApiRepository().VerifyOtp(data);
      // Save user data in session
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('Login Failed: $e');
    }
  }

  // newpassword Functionality
  Future<Map<String, dynamic>> newPassword(dynamic data) async {
    try {
      setLoading(true);
      final response = await AuthHttpApiRepository().newpassword(data);
      // Save user data in session
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('Login Failed: $e');
    }
  }

  // Signup Functionality
  Future<AuthModelResponse> signupUser(dynamic data) async {
    try {
      setLoading(true);
      final response = await authRepository.signupApi(data);

      // Save user data in session
      _authModel = response;
      await SessionController().saveAuthModelInPreference(response);
      await SessionController().getAuthModelFromPreference();
      setLoading(false);
      return response;
    } catch (e) {
      setLoading(false);
      throw Exception('Signup Failed: $e');
    }
  }

  // Logout Functionality
  Future<void> logoutUser() async {
    try {
      setLoading(true);
      await SessionController().logout();
      _authModel = null; // Clear local auth model
      _userConsumer = null; // Clear consumer data
      _savedSeller = null; // Clear saved seller data
      setLoading(false);
    } catch (e) {
      setLoading(false);
      throw Exception('Logout Failed: $e');
    }
  }

  // Load user data from session
  Future<void> loadUserFromSession() async {
    try {
      setLoading(true);
      await SessionController().getAuthModelFromPreference();
      _authModel = SessionController().authModel;
      setLoading(false);
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to load user from session: $e');
    }
  }

  // Fetch consumer data
  Future<UserConsumer> fetchConsumerData() async {
    try {
      setLoading(true);
      final token = _authModel?.response.token;
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated or token missing');
      }

      Map<String, String> headers = {'Authorization': token};
      UserConsumer userData = await HomeHttpApiRepository().fetchConsumerData(
        headers,
      );

      _userConsumer = userData;
      setLoading(false);
      notifyListeners();
      return userData;
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to fetch consumer data: $e');
    }
  }

  // Fetch saved seller data
  Future<SavedPhotographerModel> fetchSavedSeller() async {
    try {
      setLoading(true);
      final token = _authModel?.response.token;
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated or token missing');
      }

      Map<String, String> headers = {'Authorization': token};
      SavedPhotographerModel savedSellerData = await HomeHttpApiRepository()
          .fetchSavedSeller(headers);
      _savedSeller = savedSellerData;
      setLoading(false);
      notifyListeners();
      return savedSellerData;
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to fetch saved seller data: $e');
    }
  }

  Future<void> fetchSeller() async {
    final token = _authModel?.response.token;
    if (token == null || token.isEmpty) return;
    final repo = HomeHttpApiRepository();
    _seller = await repo.fetchSeller({'Authorization': token});
    notifyListeners();
  }

  // Initialize user data (consumer and saved seller)
  Future<void> initializeUserData() async {
    try {
      setLoading(true);
      await Future.wait([fetchConsumerData(), fetchSavedSeller()]);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to initialize user data: $e');
    }
  }
}
