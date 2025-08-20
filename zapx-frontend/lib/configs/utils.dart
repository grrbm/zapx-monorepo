import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:zapxx/configs/color/color.dart';

Logger logger = Logger();

showProgress() {
  Get.defaultDialog(
    backgroundColor: Colors.transparent,
    title: "",
    content: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: progressIndicator(),
    ),
    barrierDismissible: false,
  );
}

void stopProgress() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

progressIndicator({double? height, double? width}) => Builder(
  builder: (context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          color: Colors.teal,
          strokeWidth: 2.5,
        ),
      ),
    );
  },
);

class Utils {
  // we will use this function to shift focus from one text field to another text field
  // we are using to avoid duplications of code
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // generic toast message imported from toast package
  // we will utilise this for showing errors or success messages
  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColors.whiteColor,
      textColor: AppColors.backgroundColor,
    );
  }

  //imported this from flush bar package
  // we will utilise this for showing errors or success messages
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(Icons.error, size: 28, color: Colors.white),
      )..show(context),
    );
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.green,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(Icons.error, size: 28, color: Colors.white),
      )..show(context),
    );
  }

  // we will utilise this for showing errors or success messages
  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  static snackBarSuccess(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text(message)),
    );
  }
}

enum HttpStatusCode {
  ok(200), // Success
  created(201), // Resource successfully created
  badRequest(400), // Client-side error
  unauthorized(401), // Authentication required
  forbidden(403), // Access denied
  notFound(404), //Not found
  conflict(409), // Conflict occurred
  gone(410), // Resource no longer available
  unProcessableEntity(422), // Validation error or unprocessable entity
  retryWith(449), // Retry after performing action
  internalServerError(500), // Server-side error
  notImplemented(501), // Not implemented
  httpVersionNotSupported(505); // HTTP version not supported

  final int code;

  const HttpStatusCode(this.code);
}

enum HttpReasonPhrase {
  processingPhrase('Processing'),
  okPhrase('OK'),
  createdPhrase('Created'),
  acceptedPhrase('Accepted'),
  notModifiedPhrase('Not Modified'),
  useProxyPhrase('Use Proxy'),
  badRequestPhrase('Bad Request'),
  unauthorizedPhrase('Unauthorized'),
  paymentRequiredPhrase('Payment Required'),
  forbiddenPhrase('Forbidden'),
  notFoundPhrase('Not Found'),
  methodNotAllowedPhrase('Method Not Allowed'),
  notAcceptablePhrase('Not Acceptable'),
  requestTimeoutPhrase('Request Timeout'),
  conflictPhrase('Conflict'),
  gonePhrase('Gone'),
  unsupportedMediaTypePhrase('Unsupported Media Type'),
  failedDependencyPhrase('Failed Dependency'),
  tooEarlyPhrase('Too Early'),
  internalServerErrorPhrase('Internal Server Error'),
  notImplementedPhrase('Not Implemented'),
  badGatewayPhrase('Bad Gateway'),
  serviceUnavailablePhrase('Service Unavailable'),
  gatewayTimeoutPhrase('Gateway Timeout'),
  httpVersionNotSupportedPhrase('HTTP Version Not Supported');

  final String reasonPhrase;

  const HttpReasonPhrase(this.reasonPhrase);
}
