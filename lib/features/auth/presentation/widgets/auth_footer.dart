import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final VoidCallback onRegisterPressed;

  const AuthFooter({
    super.key,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('O continúa con'),
            ),
            Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: 20),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿No tienes cuenta?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: onRegisterPressed,
              child: const Text('Crea una cuenta'),
            ),
          ],
        ),
      ],
    );
  }
}