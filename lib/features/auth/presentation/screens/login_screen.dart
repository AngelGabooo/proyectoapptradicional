// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/app_logo.dart';
import '../widgets/login_form.dart';
import '../widgets/auth_footer.dart';
import 'register_screen.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // Sin botón de tema, AppBar transparente y limpio
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(),
                  const SizedBox(height: 48),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          LoginForm(
                            emailController: emailController,
                            passwordController: passwordController,
                            onLoginSuccess: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const TasksScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          AuthFooter(
                            onRegisterPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}