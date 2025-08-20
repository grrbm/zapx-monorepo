import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zapxx/configs/color/color.dart';
import 'package:zapxx/view/nav_bar/photographer/home/business_builder/service_and_schedule/service_and_schedule.dart';
import 'package:zapxx/view/nav_bar/photographer/home/other_screen/bio_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/home/other_screen/create_discount_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/home/portfolio_screen/portfolio_screen.dart';
import 'package:zapxx/view/nav_bar/photographer/nav_bar.dart';
import 'package:zapxx/view/nav_bar/photographer/profile/setting/edit_seller.dart';
import 'package:zapxx/view_model/services/session_manager/session_controller.dart';

class BusinessBuilder extends StatefulWidget {
  const BusinessBuilder({super.key});
  @override
  State<BusinessBuilder> createState() => _BusinessBuilderState();
}

class _BusinessBuilderState extends State<BusinessBuilder> {
  bool bio = false, schedule = false, portfolio = false, bank = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBool();
  }

  Future<void> getBool() async {
    bio = await SessionController.getBool(SessionController.boolKey1);
    schedule = await SessionController.getBool(SessionController.boolKey2);
    portfolio = await SessionController.getBool(SessionController.boolKey3);
    bank = await SessionController.getBool(SessionController.boolKey4);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const PhotographerNavBar();
                },
              ),
            );
          },
        ),
        title: const Text(
          'Business Builder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomCard(
              text: 'Create Bio ',
              isfirstdone: bio,
              isiconshow: bio,
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const BioScreen();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              isfirstdone: schedule,
              isiconshow: schedule,
              text: 'Services and Schedule ',
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceAndSchedule(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomCard(
              isfirstdone: portfolio,
              isiconshow: portfolio,
              text: 'Showcase Portfolio ',
              ontap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PortFolioScreen();
                    },
                  ),
                );
              },
            ),
            // const SizedBox(height: 20),
            // CustomCard2(
            //   isfirstdone: bank,
            //   isiconshow: bank,
            //   text: 'Payment Setup ',
            //   isshowSubText: true,
            //   ontap: () {
            //     bank
            //         ? null
            //         : Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) {
            //               return const PaymentScreen();
            //             },
            //           ),
            //         );
            //   },
            // ),
            const SizedBox(height: 20),
            // Container(
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //   ),
            //   width: double.infinity,
            //   height: 175,
            //   child: Row(
            //     children: [
            //       Column(
            //         children: [
            //           const SizedBox(height: 10),
            //           Row(
            //             children: [
            //               const SizedBox(width: 20),
            //               const Text(
            //                 'Offer a discount',
            //                 style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //               const SizedBox(width: 125),
            //               CupertinoSwitch(
            //                 value: bank,
            //                 onChanged: (v) {
            //                   setState(() {
            //                     bank = v;
            //                   });
            //                 },
            //                 activeColor: AppColors.backgroundColor,
            //               ),
            //               const SizedBox(width: 10),
            //             ],
            //           ),

            //           const SizedBox(height: 10),
            //           const Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 21),
            //             child: SizedBox(
            //               width: 300,
            //               child: Text(
            //                 'Offer toggle to showcase your photography services in our exclusive category. Get noticed by users seeking unique discounts and promotions.',
            //                 style: TextStyle(color: Colors.grey, fontSize: 12),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(height: 20),
            //           if (bank) ...[
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) {
            //                           return const DiscountScreen(
            //                             discount: '10',
            //                           );
            //                         },
            //                       ),
            //                     );
            //                   },
            //                   child: Container(
            //                     height: 40,
            //                     width: 90,
            //                     child: const Center(
            //                       child: Text(
            //                         '10%',
            //                         style: TextStyle(
            //                           fontSize: 17,
            //                           color: Colors.white,
            //                         ),
            //                       ),
            //                     ),
            //                     decoration: BoxDecoration(
            //                       color: AppColors.backgroundColor,
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(width: 20),
            //                 GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) {
            //                           return const DiscountScreen(
            //                             discount: '20',
            //                           );
            //                         },
            //                       ),
            //                     );
            //                   },
            //                   child: Container(
            //                     height: 40,
            //                     width: 90,
            //                     child: const Center(
            //                       child: Text(
            //                         '20%',
            //                         style: TextStyle(
            //                           fontSize: 17,
            //                           color: Colors.white,
            //                         ),
            //                       ),
            //                     ),
            //                     decoration: BoxDecoration(
            //                       color: AppColors.backgroundColor,
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(width: 20),
            //                 GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) {
            //                           return const DiscountScreen(discount: '');
            //                         },
            //                       ),
            //                     );
            //                   },
            //                   child: Container(
            //                     height: 40,
            //                     width: 90,
            //                     child: const Center(
            //                       child: Text(
            //                         '+add',
            //                         style: TextStyle(
            //                           fontSize: 17,
            //                           color: Colors.white,
            //                         ),
            //                       ),
            //                     ),
            //                     decoration: BoxDecoration(
            //                       color: AppColors.backgroundColor,
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({
    super.key,
    this.isfirstdone = false,
    this.isiconshow = false,
    this.text = "Create Bio",
    this.ontap,
  });
  final isfirstdone;
  final isiconshow;
  final text;

  final ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap ?? () {},
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: double.infinity,
        height: 70,
        child: Row(
          children: [
            Container(
              height: 66,
              width: 10,
              decoration: BoxDecoration(
                color: isfirstdone ? AppColors.backgroundColor : Colors.grey,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isiconshow ? AppColors.backgroundColor : Colors.grey,
                ),
                color: isiconshow ? AppColors.backgroundColor : Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child:
                    isiconshow
                        ? const Icon(Icons.check, color: Colors.white)
                        : const SizedBox(),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class CustomCard2 extends StatelessWidget {
  CustomCard2({
    super.key,
    this.isfirstdone = false,
    this.isiconshow = false,
    this.text = "Create Bio",
    this.isshowSubText = false,
    this.ontap,
  });
  final isfirstdone;
  final isiconshow;
  final text;
  final isshowSubText;
  final ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap ?? () {},
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: double.infinity,
        height: 150,
        child: Row(
          children: [
            Container(
              height: 150,
              width: 10,
              decoration: BoxDecoration(
                color: isfirstdone ? Colors.teal : Colors.grey,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isiconshow ? Colors.teal : Colors.grey,
                        ),
                        color: isiconshow ? Colors.teal : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child:
                            isiconshow
                                ? const Icon(Icons.check, color: Colors.white)
                                : const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 105),
                    const Icon(Icons.arrow_forward_ios),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      'Give clients the ability to pay through the app to protect your schedule. This feature allows you to charge clients through the app & protect your schedule',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
