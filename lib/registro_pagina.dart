import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'utils/validators.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

class RegistroPagina extends StatefulWidget {
  const RegistroPagina({super.key});

  @override
  State<RegistroPagina> createState() => _RegistroPaginaState();
}

class _RegistroPaginaState extends State<RegistroPagina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showMessage('Debes aceptar los términos y condiciones', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular proceso de registro
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      _showMessage('¡Registro exitoso! Ya puedes iniciar sesión');
      
      // Regresar a la página de login después de un breve delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppConstants.colorError : AppConstants.colorExito,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.colorFondo,
      appBar: AppBar(
        backgroundColor: AppConstants.colorPrimario,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppTexts.registrarse,
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
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppConstants.colorPrimario,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.colorPrimario.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: AppConstants.espaciadoExtraGrande),
                
                // Campo de nombre
                CustomTextField(
                  controller: _nombreController,
                  labelText: 'Nombre completo',
                  hintText: 'Ingresa tu nombre completo',
                  prefixIcon: Icons.person,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validarNombre,
                ),
                
                const SizedBox(height: AppConstants.espaciadoMedio),
                
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
                
                // Campo de teléfono
                CustomTextField(
                  controller: _telefonoController,
                  labelText: 'Teléfono',
                  hintText: '3123456789',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validarTelefono,
                ),
                
                const SizedBox(height: AppConstants.espaciadoMedio),
                
                // Campo de contraseña
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppTexts.contrasena,
                  hintText: 'Mínimo 6 caracteres',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validarContrasena,
                ),
                
                const SizedBox(height: AppConstants.espaciadoMedio),
                
                // Campo de confirmación de contraseña
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: AppTexts.confirmarContrasena,
                  hintText: 'Confirma tu contraseña',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validators.validarConfirmacionContrasena(
                    value,
                    _passwordController.text,
                  ),
                  onFieldSubmitted: (_) => _register(),
                ),
                
                const SizedBox(height: AppConstants.espaciadoMedio),
                
                // Checkbox de términos y condiciones
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: AppConstants.colorPrimario,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: const Text(
                          'Acepto los términos y condiciones de uso',
                          style: TextStyle(
                            color: AppConstants.colorTextoSecundario,
                            fontSize: AppConstants.tamanotPequeno,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.espaciadoExtraGrande),
                
                // Botón de registro
                CustomButton(
                  text: AppTexts.registrarse,
                  onPressed: _isLoading ? null : _register,
                  type: ButtonType.primary,
                  size: ButtonSize.large,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
                
                const SizedBox(height: AppConstants.espaciadoMedio),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 