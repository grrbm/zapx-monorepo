import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_button.dart';
import 'package:zapxx/configs/custom_global_widgets/custom_text.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/controller/payment_controller.dart';
import 'package:zapxx/view/nav_bar/user/add_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    Get.find<PaymentController>().fetchCardList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const CustomText(
          text: 'Payment Methodss',
          fontSized: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: GetBuilder<PaymentController>(
        builder: (PaymentController paymentCtrl) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Cards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                if (paymentCtrl.cardListModel?.isEmpty == true)
                  progressIndicator()
                else
                  SizedBox(
                    height: 270.h,
                    child: ListView.builder(
                      itemCount: paymentCtrl.cardListModel?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(bottom: 20),
                      itemBuilder: (context, index) {
                        return _buildCardTile(
                          cardBrand: 'Visa',
                          last4: '4242',
                          isDefault: true,
                          onDelete: () {},
                        );
                      },
                    ),
                  ),
                // _buildCardTile(
                //   cardBrand: 'Visa',
                //   last4: '4242',
                //   isDefault: true,
                //   onDelete: () {},
                // ),
                // const SizedBox(height: 12),
                // _buildCardTile(
                //   cardBrand: 'Mastercard',
                //   last4: '7890',
                //   isDefault: false,
                //   onDelete: () {},
                // ),
                const Spacer(),
                CustomButton(
                  title: '+ Add New Card',
                  onPressed: () {
                    Get.to(() => AddCardScreen());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const AddCardScreen()),
                    // );
                  },
                  btnColor: AppColors.backgroundColor,
                  btnTextColor: AppColors.whiteColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardTile({
    required String cardBrand,
    required String last4,
    required bool isDefault,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(
            cardBrand == 'Visa'
                ? Icons.credit_card
                : Icons.credit_card_outlined,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$cardBrand •••• $last4',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (isDefault)
                  const Text(
                    'Default',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
