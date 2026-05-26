// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/datasources/auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/tasks/data/datasources/task_datasource.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  // Capturar errores globalmente
  FlutterError.onError = (FlutterErrorDetails details) {
    print('═══════════════════════════════════════════════════════════');
    print('❌ ERROR: ${details.exceptionAsString()}');
    print('📍 STACK: ${details.stack}');
    print('═══════════════════════════════════════════════════════════');
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authDatasource = AuthDatasource();
    final authRepository = AuthRepositoryImpl(authDatasource);
    final authViewModel = AuthViewModel(authRepository);

    final taskDatasource = TaskDatasource();
    final taskRepository = TaskRepositoryImpl(taskDatasource);
    final taskViewModel = TaskViewModel(taskRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProvider.value(value: taskViewModel),
      ],
      child: MaterialApp(
        title: 'Recordatorios',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}