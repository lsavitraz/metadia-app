import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/app_theme.dart';
import 'package:metadia/src/pages_route/app_pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: PagesRoute.splashRoute,
      getPages: AppPages.pages,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
