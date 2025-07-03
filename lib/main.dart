import 'package:flutter/material.dart';
import 'package:rouwhite/inicio_sesion_pagina.dart';


void main() {
  runApp(const Miapp());
}

class Miapp extends StatelessWidget {
  const Miapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RouWhite - Rutas Popayán",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6A00),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6A00),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
