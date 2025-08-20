// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

class ApiResponseModel {
  final int statusCode;
  final String? errorMessage;
  final bool showButton;
  final bool success;
  final String successStatus;
  final String? reasonPhrase;
  final dynamic response;
  final dynamic specificResponse;

  ApiResponseModel({
    required this.statusCode,
    this.errorMessage,
    this.showButton = false,
    this.success = false,
    required this.successStatus,
    this.reasonPhrase,
    this.response,
    this.specificResponse,
  });

  factory ApiResponseModel.apiResponse({
    required int code,
    String? reasonPhrase,
    String? errorMessage,
    response,
    required bool success,
    required successStatus,
    dynamic specificResponse,
  }) {
    return ApiResponseModel(
      statusCode: code,
      success: success,
      reasonPhrase: reasonPhrase,
      response: response,
      errorMessage: errorMessage,
      successStatus: successStatus,
      specificResponse: specificResponse,
    );
  }

  factory ApiResponseModel.errorResponse({
    required int statusCode,
    String? errorMessage,
    bool showButton = false,
    String? reasonPhrase,
    required successStatus,
    dynamic specificResponse,
  }) {
    return ApiResponseModel(
      statusCode: statusCode,
      errorMessage: errorMessage,
      showButton: showButton,
      success: false,
      successStatus: successStatus,
      reasonPhrase: reasonPhrase,
      specificResponse: specificResponse,
    );
  }
}
