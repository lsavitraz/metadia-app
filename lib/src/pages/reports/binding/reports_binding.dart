import 'package:get/get.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';
import 'package:metadia/src/pages/reports/controller/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportsController(homeRepository: Get.find<HomeRepository>()));
  }
}