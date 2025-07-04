import 'package:flutter/material.dart';
import 'view/principal_pagina.dart';
import 'registro_pagina.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  void _login() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    bool valid = true;
    if (!email.contains('@') || !email.contains('.')) {
      _emailError = 'Correo inválido';
      valid = false;
    }
    if (password.length < 6) {
      _passwordError = 'Contraseña débil';
      valid = false;
    }
    if (!valid) {
      setState(() {});
      return;
    }
    // Aquí iría la lógica de autenticación real
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage(username: email, onLogout: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      })),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistroPagina()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFA726),
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Iniciar Sesión'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFFFFA726),
              child: const Icon(Icons.person, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: const Icon(Icons.email),
                errorText: _emailError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                errorText: _passwordError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() { _obscurePassword = !_obscurePassword; });
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _login,
                child: const Text('Iniciar Sesión'),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _goToRegister,
              child: const Text(
                '¿No tienes cuenta? Regístrate',
                style: TextStyle(color: Color(0xFFFFA726), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 