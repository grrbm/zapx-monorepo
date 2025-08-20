import 'package:zapxx/model/user/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModelResponse> loginApi(dynamic data);
  Future<AuthModelResponse> signupApi(dynamic data);
  Future<Map<String, dynamic>> chooseServices(dynamic data);
}
