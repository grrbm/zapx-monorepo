import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/data/network/base_api_services.dart';
import 'package:zapxx/data/network/network_api_services.dart';
import 'package:zapxx/model/user/auth_model.dart';
import 'auth_repository.dart';

class AuthHttpApiRepository implements AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<AuthModelResponse> loginApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.loginEndPint,
      data,
    );
    return AuthModelResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> discountSeller(
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    dynamic response = await _apiServices.getPostApiResponseHeader(
      AppUrl.discountEndPoint,
      data,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    dynamic response = await _apiServices.getUpdateApiResponse(
      AppUrl.consumerProfileEndPoint,
      data,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> updateSeller(
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    dynamic response = await _apiServices.getUpdateApiResponse(
      AppUrl.sellerBio,
      data,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> forgotPassword(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.forgotPassword,
      data,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> VerifyOtp(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.verifyOtp,
      data,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> newpassword(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.newPassword,
      data,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> editProfile(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.newPassword,
      data,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  @override
  Future<AuthModelResponse> signupApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.registerApiEndPoint,
      data,
    );
    return AuthModelResponse.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> chooseServices(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.chooseYourServise,
      data,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }
}
