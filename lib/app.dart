// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/tasks/presentation/screens/tasks_screen.dart';
import 'core/themes/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/tasks': (context) => const TasksScreen(),
      },
      onGenerateRoute: (settings) {
        // Manejo adicional de rutas si es necesario
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterScreen());
          case '/tasks':
            return MaterialPageRoute(builder: (_) => const TasksScreen());
          default:
            return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      },
    );
  }
}
