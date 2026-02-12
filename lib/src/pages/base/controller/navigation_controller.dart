import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    if(currentIndex.value != index) {
      currentIndex.value = index;
    }
  }
}
