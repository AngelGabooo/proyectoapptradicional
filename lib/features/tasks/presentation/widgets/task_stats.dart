// lib/features/tasks/presentation/widgets/task_stats.dart
import 'package:flutter/material.dart';

class TaskStats extends StatelessWidget {
  final int pendingCount;
  final int completedCount;

  const TaskStats({
    super.key,
    required this.pendingCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatChip(
            label: 'Pendientes: $pendingCount',
            icon: Icons.pending_actions,
            color: primaryColor,
          ),
          _buildStatChip(
            label: 'Completadas: $completedCount',
            icon: Icons.check_circle,
            color: secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 18, color: color),
      side: BorderSide(color: color.withOpacity(0.3)),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}