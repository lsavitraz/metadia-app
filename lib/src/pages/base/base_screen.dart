import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/pages/base/controller/navigation_controller.dart';
import 'package:metadia/src/pages/home/view/home_tab.dart';
import 'package:metadia/src/pages/reports/view/reports_tab.dart';
import 'package:metadia/src/pages_route/app_pages.dart';

class BaseScreen extends GetView<NavigationController> {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _BuildPage(
              controller.currentIndex.value,
            ),
          );
        }
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(PagesRoute.createMetaRoute);
        },
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        elevation: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(icon: Icons.home, index: 0),
              _NavItem(icon: Icons.bar_chart, index: 1),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _BuildPage(int index) {
  switch (index) {
    case 0:
      return const HomeTab(key: ValueKey(0));
    case 1:
      return const ReportsTab(key: ValueKey(1));
    default:
      return const HomeTab(key: ValueKey(0));
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  const _NavItem({super.key, required this.icon, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return IconButton(
        onPressed: () => controller.changeTab(index),
        icon: Icon(
          icon, 
          size: 26,
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          splashRadius: 22,
        );
    });
  }
}
