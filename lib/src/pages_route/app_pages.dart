import 'package:get/get.dart';
import 'package:metadia/src/pages/base/binding/navigation_binding.dart';
import 'package:metadia/src/pages/create_meta/binding/create_meta_binding.dart';
import 'package:metadia/src/pages/create_meta/view/create_meta_screen.dart';
import 'package:metadia/src/pages/home/binding/home_binding.dart';
import 'package:metadia/src/pages/reports/binding/reports_binding.dart';
import 'package:metadia/src/pages/reports/view/reports_tab.dart';
import 'package:metadia/src/pages/splash/splash_screen.dart';
import 'package:metadia/src/pages/base/base_screen.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: PagesRoute.splashRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: PagesRoute.createMetaRoute,
      page: () => const CreateMetaScreen(),
      binding: CreateMetaBinding(),
    ),
    GetPage(
      name: PagesRoute.baseRoute, 
      page: () => const BaseScreen(),
      bindings: [
        HomeBinding(),
        NavigationBinding(),
        ReportsBinding(),
      ],
    ),
  ];
}

abstract class PagesRoute {
  static const String splashRoute = '/splash';
  static const String baseRoute = '/';
  static const String createMetaRoute = '/create-meta';
  static const String reportsRoute = '/reports';
}
