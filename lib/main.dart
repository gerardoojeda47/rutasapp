import 'package:flutter/material.dart';
import 'package:rouwhite/inicio_sesion_pagina.dart';
import 'constants/app_constants.dart';
import 'utils/theme.dart';

void main() {
  runApp(const Miapp());
}

class Miapp extends StatelessWidget {
  const Miapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "${AppConstants.appName} - ${AppConstants.appSubtitle}",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Se puede hacer dinámico más adelante
      home: const LoginPage(),
    );
  }
}
