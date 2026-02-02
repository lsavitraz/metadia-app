import 'package:get/get.dart';
import 'package:metadia/src/pages/home/binding/home_binding.dart';
import 'package:metadia/src/pages/splash/splash_screen.dart';
import 'package:metadia/src/pages/base/base_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: PagesRoute.splashRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: PagesRoute.baseRoute, 
      page: () => const BaseScreen(),
      bindings: [
        HomeBinding(),
      ],
    ),
  ];
}

abstract class PagesRoute {
  static const String splashRoute = '/splash';
  static const String baseRoute = '/';
}
