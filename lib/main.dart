import 'package:flutter/material.dart';
import 'package:rouwhite/view/HomePage.dart';
import 'login_page.dart';

void main() {
  runApp(const Miapp());
}

class Miapp extends StatefulWidget {
  const Miapp({super.key});

  @override
  State<Miapp> createState() => _MiappState();
}

class _MiappState extends State<Miapp> {
  bool _loggedIn = false;
  String? _username;

  void _onLoginSuccess(String username) {
    setState(() {
      _loggedIn = true;
      _username = username;
    });
  }

  void _logout() {
    setState(() {
      _loggedIn = false;
      _username = null;
    });
  }

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
      home: _loggedIn
          ? Homepage(username: _username!, onLogout: _logout)
          : LoginPage(onLoginSuccess: _onLoginSuccess),
    );
  }
}
