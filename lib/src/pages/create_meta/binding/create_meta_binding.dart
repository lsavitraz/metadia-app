import 'package:get/get.dart';
import 'package:metadia/src/pages/create_meta/controller/create_meta_controller.dart';
import 'package:metadia/src/pages/home/repository/home_repository.dart';

class CreateMetaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateMetaController(Get.find<HomeRepository>()));
  }

}