import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadia/src/pages/home/view/home_tab.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MetaDia'),
        actions: [
          IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            //DESENVOLVER FUTURAMENTE UMA TELA DE PERFIL
            }
          ),
        ],
      ),
      body: const HomeTab(),
    );
  }
}
