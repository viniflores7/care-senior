import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:care_senior_study/services/auth_service.dart';

class GuardianLoginScreenViewModel extends ChangeNotifier {
  final _authService = GetIt.I<AuthService>();

  final emailController = TextEditingController(text: 'familia@teste.com');
  final passwordController = TextEditingController(text: '123456');

  bool isLoading = false;
  String? errorMessage;

  Future<void> login(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await _authService.loginGuardian(
      email: emailController.text.trim(),
      password: passwordController.text,
      context: context,
    );

    if (!success) {
      errorMessage = 'E-mail ou senha inválidos.';
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
