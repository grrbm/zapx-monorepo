import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_app_bar.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/controller/payment_controller.dart';

import '../../../../../../configs/app_url.dart';
import '../../../../../../configs/utils.dart';
import '../../../../../../view_model/services/session_manager/session_controller.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  bool isChecked = false;

  PaymentController paymentController = Get.find<PaymentController>();

  @override
  void initState() {
    paymentController.noShowFeeCtrl.clear();
    paymentController.cancellationFeeCtrl.clear();
    paymentController.routingNumberCtrl.clear();
    paymentController.accountNumberCtrl.clear();
    paymentController.accountHolderNameCtrl.clear();
    super.initState();
  }

  Future<void> createBank() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      setState(() {
        _isLoading = true;
      });

      showProgress();
      // Prepare the JSON body
      final Map<String, dynamic> requestBody = {
        "accountHolderName": paymentController.accountHolderNameCtrl.text,
        "accountNumber": paymentController.accountNumberCtrl.text,
        "routingNumber": paymentController.routingNumberCtrl.text,
        "cancellationFee": "${paymentController.cancellationFeeCtrl.text}%",
        "noShowFee": "${paymentController.noShowFeeCtrl.text}%",
        "country": "PK",
      };

      logger.i(requestBody);

      final response = await dio.post(
        AppUrl.bankDetail, // Replace with your API endpoint
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': token,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      stopProgress();
      if (response.statusCode == 200) {
        logger.i(response.data);
        Utils.snackBarSuccess('Successful!', context);
        stopProgress();
        Get.back();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please try again.')));
      }
    } on DioException catch (e) {
      stopProgress();
      logger.e('Error: ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.response?.data['message'] ?? 'Failed')),
      );
    } catch (e) {
      stopProgress();
      logger.e('General error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.96),
      appBar: CustomAppBar(title: 'Payment', backgroundColor: Colors.white),
      body: GetBuilder<PaymentController>(
        builder: (PaymentController paymentCtrl) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    height: 70.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CustomText(
                            text: 'Payment Setup Feature',
                            color: Colors.grey,
                            fontSized: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: CustomText(
                            alignment: TextAlign.start,
                            maxLines: 2,
                            text:
                                'This feature allows users to charge customers within the app.',
                            color: Colors.black,
                            fontSized: 14.sp,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomText(
                    text: 'Enter Bank Details',
                    color: Colors.black,
                    fontSized: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: paymentCtrl.accountHolderNameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Account Holder',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(.1),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: paymentCtrl.accountNumberCtrl,
                    decoration: InputDecoration(
                      hintText: 'Account Number',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(.1),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: paymentCtrl.routingNumberCtrl,
                    decoration: InputDecoration(
                      hintText: 'Routing Number',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(.1),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'PK',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.grey.withOpacity(.1),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(35),
                        borderSide: BorderSide(
                          width: 0.2,
                          color: Colors.grey.withOpacity(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        activeColor: AppColors.backgroundColor,
                      ),
                      CustomText(
                        text: 'Set Cancellation/No Show Fee',
                        color: Colors.black,
                        fontSized: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  if (isChecked) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: CustomText(
                        text: 'Cancellation Fee',
                        color: Colors.black,
                        fontSized: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomWidget(
                          text: '100%',
                          isSelected: paymentCtrl.selectedOption == '100%',
                          onTap: () {
                            paymentCtrl.selectedOption = '100%';
                            paymentCtrl.cancellationFeeCtrl.text = '100';
                            paymentCtrl.update();
                          },
                        ),
                        CustomWidget(
                          text: 'Default',
                          isSelected: paymentCtrl.selectedOption == 'Default',
                          onTap: () {
                            paymentCtrl.selectedOption = 'Default';
                            paymentCtrl.cancellationFeeCtrl.text = '10';
                            paymentCtrl.update();
                          },
                        ),
                        CustomWidget(
                          text: 'Custom',
                          isSelected: paymentCtrl.selectedOption == 'Custom',
                          onTap: () {
                            paymentCtrl.selectedOption = 'Custom';
                            paymentCtrl.cancellationFeeCtrl.clear();
                            paymentCtrl.update();
                          },
                        ),
                      ],
                    ),
                    if (paymentCtrl.selectedOption == 'Custom') ...[
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: paymentCtrl.cancellationFeeCtrl,
                        keyboardType:
                            TextInputType.number, // Allows only numbers
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Restricts input to digits only
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter Custom Fee",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.grey.withOpacity(.1),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(
                              width: 0.2,
                              color: Colors.grey.withOpacity(0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(
                              width: 0.2,
                              color: Colors.grey.withOpacity(0),
                            ),
                          ),
                        ),
                      ),
                      // TextField(
                      //   controller: feeCtrl,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     labelText: "Enter Fee",
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                    ],

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     CustomWidget(text: '100%'),
                    //     CustomWidget(text: 'Default'),
                    //     CustomWidget(text: 'Custom'),
                    //   ],
                    // ),
                  ],

                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: CustomText(
                      text: 'No Show Fee',
                      color: Colors.black,
                      fontSized: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidget(
                        text: '100%',
                        isSelected: paymentCtrl.selectedOption2 == '100%',
                        onTap: () {
                          paymentCtrl.selectedOption2 = '100%';
                          paymentCtrl.noShowFeeCtrl.text = '100';
                          paymentCtrl.update();
                        },
                      ),
                      CustomWidget(
                        text: 'Default',
                        isSelected: paymentCtrl.selectedOption2 == 'Default',
                        onTap: () {
                          paymentCtrl.selectedOption2 = 'Default';
                          paymentCtrl.noShowFeeCtrl.text = '10';
                          paymentCtrl.update();
                        },
                      ),
                      CustomWidget(
                        text: 'Custom',
                        isSelected: paymentCtrl.selectedOption2 == 'Custom',
                        onTap: () {
                          paymentCtrl.selectedOption2 = 'Custom';
                          paymentCtrl.noShowFeeCtrl.clear();
                          paymentCtrl.update();
                        },
                      ),
                    ],
                  ),
                  if (paymentCtrl.selectedOption2 == 'Custom') ...[
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: paymentCtrl.noShowFeeCtrl,
                      keyboardType: TextInputType.number, // Allows only numbers
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Restricts input to digits only
                      ],
                      decoration: InputDecoration(
                        hintText: "Enter Custom Fee",
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey.withOpacity(.1),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            width: 0.2,
                            color: Colors.grey.withOpacity(0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(
                            width: 0.2,
                            color: Colors.grey.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                    // TextField(
                    //   controller: feeCtrl,
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     labelText: "Enter Fee",
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                  ],
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     // CustomWidget(text: '50%'),
                  //     // CustomWidget(text: 'Default'),
                  //     // CustomWidget(text: 'Custom'),
                  //   ],
                  // ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    title: 'Save',
                    onPressed: () {
                      createBank();
                    },
                    btnColor: AppColors.backgroundColor,
                    btnTextColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class CustomWidget extends StatelessWidget {
//   CustomWidget({super.key, this.text});
//
//   final text;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40.h,
//       width: 100.w,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(35),
//         color: Colors.grey.withOpacity(.1),
//       ),
//       child: Center(child: Text(text, style: TextStyle(color: Colors.grey))),
//     );
//   }
// }

class CustomWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color:
              isSelected
                  ? AppColors.backgroundColor
                  : Colors.grey.withOpacity(.1),
          // border: Border.all(
          //   color: isSelected ? Colors.blue : Colors.transparent,
          //   width: 2,
          // ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
          ),
        ),
      ),
    );
  }
}
