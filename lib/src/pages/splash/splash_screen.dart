import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/config/color_scheme.dart';
import 'package:metadia/src/pages_route/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  static const _fadeDuration = Duration(milliseconds: 1200);
  static const _visibleDelay = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _fadeDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Delay para o logo "respirar" na tela
        await Future.delayed(_visibleDelay);

        if (mounted) {
          Get.offNamed(PagesRoute.baseRoute);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(_fadeAnimation),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 120,
              ),
              const SizedBox(height: 16),
              Text(
                'MetaDia',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
            ),
        ),
      ),
    );
  }
}