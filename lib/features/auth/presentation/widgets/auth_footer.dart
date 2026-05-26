// lib/features/auth/presentation/widgets/auth_footer.dart
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

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, size: 20),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.apple, size: 20),
                label: const Text('Apple'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),

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