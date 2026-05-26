// lib/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/error_display.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginSuccess;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido de vuelta',
            style: Theme.of(context).textTheme.titleLarge ?? const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'Inicia sesión para continuar',
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 32),

          CustomTextField(
            controller: emailController,
            label: 'Correo electrónico',
            hint: 'usuario@ejemplo.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: passwordController,
            label: 'Contraseña',
            hint: 'Ingresa tu contraseña',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),

          const SizedBox(height: 24),

          if (authViewModel.error != null && authViewModel.error!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ErrorDisplay(message: authViewModel.error!),
            ),

          PrimaryButton(
            onPressed: () async {
              final success = await authViewModel.login(
                emailController.text.trim(),
                passwordController.text,
              );
              if (success) {
                onLoginSuccess();
              }
            },
            text: 'Iniciar Sesión',
            isLoading: authViewModel.isLoading,
          ),
        ],
      );
    } catch (e, stack) {
      print('❌ Error en LoginForm.build: $e');
      print(stack);
      return const Center(child: Text('Error en el formulario de login'));
    }
  }
}