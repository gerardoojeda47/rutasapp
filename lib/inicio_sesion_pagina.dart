import 'package:flutter/material.dart';
import 'view/principal_pagina.dart';
import 'registro_pagina.dart';
import 'constants/app_constants.dart';
import 'utils/validators.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular proceso de autenticación
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navegar a la página principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(
            username: _emailController.text.trim(),
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ),
      );
    }
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
      backgroundColor: AppConstants.colorFondo,
      appBar: AppBar(
        backgroundColor: AppConstants.colorPrimario,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          AppTexts.iniciarSesion,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.espaciadoGrande),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: AppConstants.espaciadoMedio),
                
                // Logo/Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppConstants.colorPrimario,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.colorPrimario.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: AppConstants.espaciadoExtraGrande),
                
                // Campo de email
                CustomTextField(
                  controller: _emailController,
                  labelText: AppTexts.correoElectronico,
                  hintText: 'ejemplo@correo.com',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validarEmail,
                ),
                
                const SizedBox(height: AppConstants.espaciadoMedio),
                
                // Campo de contraseña
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppTexts.contrasena,
                  hintText: 'Ingresa tu contraseña',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.validarContrasena,
                  onFieldSubmitted: (_) => _login(),
                ),
                
                const SizedBox(height: AppConstants.espaciadoExtraGrande),
                
                // Botón de iniciar sesión
                CustomButton(
                  text: AppTexts.iniciarSesion,
                  onPressed: _isLoading ? null : _login,
                  type: ButtonType.primary,
                  size: ButtonSize.large,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
                
                const SizedBox(height: AppConstants.espaciadoGrande),
                
                // Enlace a registro
                CustomButton(
                  text: AppTexts.noTienesCuenta,
                  onPressed: _goToRegister,
                  type: ButtonType.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 