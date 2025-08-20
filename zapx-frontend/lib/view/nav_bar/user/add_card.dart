import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';

import '../../../configs/app_url.dart';
import '../../../configs/utils.dart';
import '../../../view_model/services/session_manager/session_controller.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    cardNumberController.clear();
    expiryDateController.clear();
    cvcController.clear();
    nameController.clear();
    super.initState();
  }

  Future<void> createCard() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppUrl.baseUrl));
      final token = SessionController().authModel.response.token;

      setState(() {
        _isLoading = true;
      });

      showProgress();
      // Prepare the JSON body
      final Map<String, dynamic> requestBody = {
        "cardHolderName": nameController.text,
        "cardNumber": cardNumberController.text,
        "expiryDate": expiryDateController.text,
        "cvvCvc": cvcController.text,
        "isPrimaryPaymentMethod": true,
      };
      // "paymentMethodId": "3",
      logger.i(requestBody);

      final response = await dio.post(
        AppUrl.cardDetail, // Replace with your API endpoint
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
        Utils.flushBarSuccessMessage('Card Added Successfully!', context);
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
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const CustomText(
          text: 'Add New Card',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputField(
                label: 'Cardholder Name',
                controller: nameController,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Card Number',
                controller: cardNumberController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'Expiry Date (MM/YY)',
                      controller: expiryDateController,
                      keyboardType: TextInputType.text,
                      limit: 10,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInputField(
                      label: 'CVC',
                      controller: cvcController,
                      keyboardType: TextInputType.number,
                      limit: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                title: 'Save Card',
                onPressed: () {
                  createCard();
                },
                btnColor: AppColors.backgroundColor,
                btnTextColor: AppColors.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int limit = 40,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPoppinText(
          text: label,
          fontSized: 14.0,
          color: AppColors.blackColor,
          alignment: TextAlign.left,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: [
            LengthLimitingTextInputFormatter(limit), // Limit input to 4 digits
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
