// lib/core/widgets/app_logo.dart
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Estilos seguros con fallbacks
    final headlineStyle = Theme.of(context).textTheme.headlineLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: (colorScheme.primary ?? Colors.blue).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_none,
            size: size * 0.5,
            color: colorScheme.primary ?? Colors.blue,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Recordatorios',
          style: headlineStyle?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Organiza tus tareas de forma simple',
          style: bodyStyle ?? const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}