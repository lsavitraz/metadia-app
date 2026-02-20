import 'package:get/get.dart';
import 'package:metadia/src/pages/home/controller/home_controller.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';
import 'package:metadia/src/pages/home/repository/home_repository_sqlite.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repository (mock por enquanto)
    Get.lazyPut<HomeRepository>(
      () => HomeRepositorySqlite(),
      fenix: true,
    );

    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<HomeRepository>()),
    );
  }
}