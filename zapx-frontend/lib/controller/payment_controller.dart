import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/utils.dart';

import '../configs/app_url.dart';
import '../model/card_list_model.dart';
import 'api_services.dart';

class PaymentController extends GetxController {
  TextEditingController accountHolderNameCtrl = TextEditingController();
  TextEditingController accountNumberCtrl = TextEditingController();
  TextEditingController routingNumberCtrl = TextEditingController();
  String selectedOption = "100%"; // Default selected option
  String selectedOption2 = "100%"; // Default selected option
  TextEditingController cancellationFeeCtrl = TextEditingController();
  TextEditingController noShowFeeCtrl = TextEditingController();

  List<CardListModel>? cardListModel;
  Future fetchCardList() async {
    await ApiServices.getMethod(feedUrl: AppUrl.cardDetail)
        .then((res) {
          if (res == null || res.response == null) {
            // ApiServices.showSnackBarErrorsIfAuthorized(
            //   reasonPhrase: res?.reasonPhrase,
            //   errorMessage: res?.errorMessage ?? '',
            //   statusCode: res?.statusCode,
            //   isLoggedIn: true,
            // );
            return null;
          }
          if (res.success == true) {
            cardListModel = cardListModelFromJson(res.response);
            // profileModel = profileModelFromJson(res.response);
          }
          update();
        })
        .onError((error, stackTrace) async {
          // await ExceptionController().exceptionAlert(
          //   errorMsg: '$error',
          //   exceptionFormat: ApiServices.methodExceptionFormat(
          //     'GET',
          //     ApiUrls.profileApi,
          //     error,
          //     stackTrace,
          //   ),
          // );
          logger.e('StackTrace => $stackTrace');
          throw '$error';
        });
  }
}
