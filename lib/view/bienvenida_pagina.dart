import 'package:flutter/material.dart';
import 'dart:async';
import 'principal_pagina.dart';
import 'widgets/welcome_animation_pro_widget.dart';
import '../core/services/navigation_service.dart';

class BienvenidaPagina extends StatefulWidget {
  const BienvenidaPagina({super.key});

  @override
  State<BienvenidaPagina> createState() => _BienvenidaPaginaState();
}

class _BienvenidaPaginaState extends State<BienvenidaPagina> {
  bool _isLoading = true;
  bool _showContent = false;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeWelcome();
  }

  Future<void> _initializeWelcome() async {
    // Simular tiempo de carga para mostrar animaciones
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Mostrar contenido
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    }
  }

  void _onAnimationComplete() {
    setState(() {
      _animationComplete = true;
    });

    // Esperar un poco más y navegar directamente a la página principal
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _navigateToMainApp();
      }
    });
  }

  void _navigateToMainApp() {
    NavigationService.pushReplacementWithSafeTransition(
      context,
      const Homepage(username: 'Usuario'),
      type: TransitionType.fade,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6A00),
              Color(0xFFFF8C42),
              Color(0xFFFFB74D),
              Color(0xFFFFE0B2),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Indicador de carga inicial
              if (_isLoading)
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                ),

              // Contenido principal con animaciones
              if (_showContent)
                AnimatedOpacity(
                  opacity: _showContent ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: WelcomeAnimationProWidget(
                    onFinish: _onAnimationComplete,
                    appName: 'RouWhite',
                    primary: const Color(0xFFFF6A00),
                    secondary: const Color(0xFFFF8C42),
                    coolMessages: const [
                      'Rutas inteligentes en tiempo real',
                      'Paradas cercanas al alcance de un toque',
                      'Explora Popayán con estilo',
                    ],
                    lottieAssetPath: 'assets/animaciones/bus.json',
                  ),
                ),

              // Indicador de progreso después de la animación
              if (_animationComplete)
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _animationComplete ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Preparando tu experiencia...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cargando rutas y paradas',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

