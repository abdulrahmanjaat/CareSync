import 'package:flutter/material.dart';
import 'login_screen.dart';

/// Auth Screen - Routes to Login screen by default
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
