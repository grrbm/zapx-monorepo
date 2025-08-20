import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:zapxx/controller/payment_controller.dart';
import 'package:zapxx/repository/auth_api/auth_http_api_repository.dart';
import 'package:zapxx/repository/auth_api/auth_repository.dart';
import 'package:zapxx/view/splash/splash_view.dart';
import 'package:zapxx/view_model/user_view_model.dart';

import 'controller/post_controller.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

GetIt getIt = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_live_51QKafaGCSLbjY8sonKbaxpx7PGHtM4JnGiaYE0t7KHRtTzQIT273hv8I2ipIglrILZ2h4YIfe2lDDJ3fdYLGLjmj00Ctw3N6Ko";
  await Stripe.instance.applySettings();
  getIt.registerLazySingleton<AuthRepository>(() => AuthHttpApiRepository());
  Get.put(PostController());
  Get.put(PaymentController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserViewModel(authRepository: getIt()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 654),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'ZAPX',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
            ),
            home: child,
          );
        },
        child: const SplashView(),
      ),
    );
  }
}
