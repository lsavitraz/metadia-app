import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/app_theme.dart';
import 'package:metadia/src/pages_route/app_pages.dart';

void main() {
  runApp(const MetaDiaApp());
}

class MetaDiaApp extends StatelessWidget {
  const MetaDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MetaDia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: PagesRoute.splashRoute,
      getPages: AppPages.pages,
    );
  }
}