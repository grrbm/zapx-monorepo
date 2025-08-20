import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zapxx/configs/utils.dart';

import '../model/api_response_model.dart';
import '../view_model/services/session_manager/session_controller.dart';

class ApiServices {
  //getMethod
  static Future<ApiResponseModel?> getMethod({
    required String feedUrl,
    bool notLogin = false,
  }) async {
    final token =
        SessionController()
            .authModel
            .response
            .token; // Replace with the actual token
    Map<String, String> headers = {
      'Authorization': token,
      'Accept': 'application/json',
    };

    var request = http.Request('GET', Uri.parse(feedUrl));

    request.headers.addAll(headers);

    // if (kDebugMode) {
    //   logger.i(request.headers);
    //   logger.i(request.body);
    // }

    // if(notLogin == false){
    //
    // }
    return await request
        .send()
        .then((http.StreamedResponse response) async {
          String result = await response.stream.bytesToString();

          var decodedBody = json.decode(result);
          var data = decodedBody['data'];
          var success = decodedBody['success'];
          var errors = decodedBody['errors'];

          return await handleApiResponse(
            response: response,
            success: success,
            result: result,
            feedUrl: feedUrl,
            data: data,
            decodedBody: decodedBody,
            errors: errors,
            isLogin: !notLogin,
          );
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace $stackTrace');

          return ApiResponseModel.apiResponse(
            code: HttpStatusCode.internalServerError.code,
            success: false,
            errorMessage: 'somethingHappenedWrongTryLater'.tr,
            successStatus: 'false',
          );
        });
  }

  //Post MethodRequest
  static Future<ApiResponseModel?> postMethodRequest({
    required feedUrl,
    // Map<String, String>? fields,
    required String fields,
  }) async {
    final token =
        SessionController()
            .authModel
            .response
            .token; // Replace with the actual token
    Map<String, String> headers = {
      'Authorization': token,
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(feedUrl));

    request.body = fields;

    request.headers.addAll(headers);
    if (kDebugMode) {
      logger.i(headers);
      logger.i(fields);
    }

    return await request
        .send()
        .then((http.StreamedResponse response) async {
          String result = await response.stream.bytesToString();
          var decodedBody = json.decode(result);
          var data = decodedBody['data'];
          var success = decodedBody['success'];
          var errors = decodedBody['errors'];

          ApiResponseModel res = await handleApiResponse(
            response: response,
            success: success,
            result: result,
            feedUrl: feedUrl,
            data: data,
            decodedBody: decodedBody,
            errors: errors,
            isLogin: true,
          );
          return res;
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace $stackTrace');
          // await ExceptionController().exceptionAlert(
          //   errorMsg: 'somethingHappenedWrongTryLater'.tr,
          //   exceptionFormat: methodExceptionFormat(
          //       'POST', '', 'somethingHappenedWrongTryLater', ''),
          // );
          return ApiResponseModel.apiResponse(
            code: HttpStatusCode.internalServerError.code,
            success: false,
            errorMessage: 'somethingHappenedWrongTryLater'.tr,
            successStatus: 'false',
          );
        });
  }

  static Future<ApiResponseModel> handleApiResponse({
    required http.StreamedResponse response,
    required var success,
    required dynamic result,
    required String feedUrl,
    required dynamic data,
    required var decodedBody,
    required var errors,
    required bool isLogin,
    bool isInvestment = false,
  }) async {
    var errorsMsg = '';
    if (response.statusCode == HttpStatusCode.ok.code ||
        response.statusCode == HttpStatusCode.created.code ||
        success == 'true') {
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: result,
        reasonPhrase: response.reasonPhrase,
        success: true,
        errorMessage: errorsMsg,
        successStatus: '$success',
      );
    } else if (response.statusCode >= HttpStatusCode.internalServerError.code &&
        response.statusCode <= HttpStatusCode.httpVersionNotSupported.code) {
      if (kDebugMode) {
        logger.i('serverError'.tr);
      }
      // return HttpReasonPhrase.internalServerErrorPhrase.reasonPhrase;
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: null,
        specificResponse: result,
        reasonPhrase: HttpReasonPhrase.internalServerErrorPhrase.reasonPhrase,
        success: false,
        errorMessage: errorsMsg,
        successStatus: '$success',
      );
    } else if (response.statusCode == HttpStatusCode.unauthorized.code ||
        response.reasonPhrase ==
            HttpReasonPhrase.unauthorizedPhrase.reasonPhrase) {
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: null,
        specificResponse: result,
        reasonPhrase: response.reasonPhrase,
        success: false,
        errorMessage: errorsMsg,
        successStatus: '$success',
      );
      // return null;
    } else if (decodedBody.containsKey('errors') &&
        decodedBody['errors'] != null) {
      // errorsMsg = await checkErrors(
      //   errors,
      //   feedUrl,
      //   response,
      //   response.statusCode,
      //   response.reasonPhrase,
      // );
      if (kDebugMode) {
        logger.i('ErrorsMsg = $errorsMsg');
      }
      logger.i('Error in Errors --->>> $errorsMsg');
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: null,
        specificResponse: result,
        reasonPhrase: response.reasonPhrase,
        success: false,
        errorMessage: errorsMsg,
        successStatus: '$success',
      );
      // return null;
    } else if (response.statusCode == HttpStatusCode.forbidden.code ||
        response.reasonPhrase ==
            HttpReasonPhrase.forbiddenPhrase.reasonPhrase) {
      // showErrorSnackBar(errorMessage: 'youAreNotAllowedToPerformThisAction'.tr);
      // showToast('youAreNotAllowedToPerformThisAction'.tr);
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: null,
        specificResponse: result,
        reasonPhrase: response.reasonPhrase,
        success: false,
        errorMessage: errorsMsg,
        successStatus: '$success',
      );
      // return null;
    } else if ((response.statusCode == HttpStatusCode.badRequest.code ||
        response.reasonPhrase ==
            HttpReasonPhrase.badRequestPhrase.reasonPhrase)) {
      // await ExceptionController().exceptionAlert(
      //   errorMsg: 'somethingHappenedWrongTryLater'.tr,
      //   exceptionFormat: methodExceptionFormat(
      //     'GET',
      //     '',
      //     'somethingHappenedWrongTryLater',
      //     '',
      //   ),
      // );
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: null,
        specificResponse: result,
        reasonPhrase: response.reasonPhrase,
        success: false,
        errorMessage: errorsMsg,
        successStatus: '$success',
      );
      // return null;
    } else if (success == 'false') {
      if (data is List && data.isEmpty) {
        // await ExceptionController().errorAlert(
        //   errorMsg: 'theGivenDataWasInvalid'.tr,
        //   resBody: 'theGivenDataWasInvalid'.tr,
        //   exceptionFormat: apiExceptionFormat(
        //     'POST',
        //     feedUrl,
        //     response.statusCode,
        //     'theGivenDataWasInvalid'.tr,
        //   ),
        // );
        return ApiResponseModel.apiResponse(
          code: response.statusCode,
          response: null,
          specificResponse: result,
          reasonPhrase: response.reasonPhrase,
          success: false,
          errorMessage: errorsMsg,
          successStatus: '$success',
        );
        // return null;
      }
    }
    // else if (data != null &&
    //     data.containsKey(TwoFADriver.two_fa_driver.value)) {
    //   return ApiResponseModel.apiResponse(
    //     code: response.statusCode,
    //     // response: result,
    //     response: TwoFADriver.two_fa_driver.value,
    //     specificResponse: result,
    //     reasonPhrase: TwoFADriver.two_fa_driver.value,
    //     success: false,
    //     errorMessage: errorsMsg,
    //     successStatus: '$success',
    //   );
    //   // return TwoFADriver.two_fa_driver.value;
    // }
    else {
      // await ExceptionController().exceptionAlert(
      //   errorMsg: 'somethingHappenedWrongTryLater'.tr,
      //   exceptionFormat: methodExceptionFormat(
      //     'GET',
      //     '',
      //     'somethingHappenedWrongTryLater',
      //     '',
      //   ),
      // );
      // Fallback return statement
      return ApiResponseModel.apiResponse(
        code: response.statusCode,
        response: null,
        specificResponse: result,
        reasonPhrase: HttpReasonPhrase.internalServerErrorPhrase.reasonPhrase,
        success: false,
        errorMessage: 'somethingHappenedWrongTryLater'.tr,
        successStatus: '$success',
      );
      // return null;
    }
    // Fallback return statement
    return ApiResponseModel.apiResponse(
      code: response.statusCode,
      response: null,
      specificResponse: result,
      reasonPhrase: HttpReasonPhrase.internalServerErrorPhrase.reasonPhrase,
      success: false,
      errorMessage: 'somethingHappenedWrongTryLater'.tr,
      successStatus: '$success',
    );
  }
}
