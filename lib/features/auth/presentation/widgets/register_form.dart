// lib/features/auth/presentation/widgets/register_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/error_display.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onRegisterSuccess;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onRegisterSuccess,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crear cuenta',
            style: Theme.of(context).textTheme.titleLarge ?? const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'Regístrate para comenzar',
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 32),

          CustomTextField(
            controller: nameController,
            label: 'Nombre completo',
            hint: 'Tu nombre',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

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
            hint: 'Crea una contraseña segura',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),

          const SizedBox(height: 24),

          if (authViewModel.error != null && authViewModel.error!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ErrorDisplay(message: authViewModel.error!),
            ),

          PrimaryButton(
            onPressed: () async {
              final success = await authViewModel.register(
                emailController.text.trim(),
                passwordController.text,
                nameController.text.trim(),
              );
              if (success) {
                onRegisterSuccess();
              }
            },
            text: 'Registrarse',
            isLoading: authViewModel.isLoading,
          ),
        ],
      );
    } catch (e, stack) {
      print('❌ Error en RegisterForm.build: $e');
      print(stack);
      return const Center(child: Text('Error en el formulario de registro'));
    }
  }
}