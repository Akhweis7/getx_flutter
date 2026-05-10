import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../views/screens/kanban_board_screen.dart';

class AuthController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Reactive state
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxString errorMessage = ''.obs;

  final AuthService _authService = AuthService();
  final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId:
              '379014504202-6ojasthm1cjls3l8bvpgmq6eevcbqssa.apps.googleusercontent.com',
          scopes: ['email', 'profile', 'openid'],
        )
      : GoogleSignIn(
          serverClientId:
              '379014504202-6ojasthm1cjls3l8bvpgmq6eevcbqssa.apps.googleusercontent.com',
          scopes: ['email', 'profile', 'openid'],
        );

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$')
        .hasMatch(email.trim());
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorSnackbar('Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authService.login(username, password);
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        _showSuccessSnackbar('Welcome back', 'Logged in successfully');
        Get.offAll(() => KanbanBoardScreen(username: username));
      } else {
        _showErrorSnackbar(
            'Login failed (${result['statusCode']}). ${result['body']}');
      }
    } catch (e) {
      _showErrorSnackbar('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorSnackbar('Please fill all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Please enter a valid email address');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackbar('Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final result = await _authService.signUp(username, email, password);
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        _showSuccessSnackbar(
          'Account Created',
          'Welcome, $username! Your account was created successfully.',
        );
        _clearRegisterFields();
        Get.offAll(() => KanbanBoardScreen(username: username));
      } else {
        _showErrorSnackbar(
            'Signup failed (${result['statusCode']}). ${result['body']}');
      }
    } catch (e) {
      _showErrorSnackbar('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  Future<void> googleSignUp() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return;

      final auth = await account.authentication;
      final idToken = auth.idToken;

      print('Google idToken: $idToken');
      print('Google accessToken: ${auth.accessToken}');

      if (idToken == null) {
        _showErrorSnackbar('Failed to get Google token');
        return;
      }

      isLoading.value = true;
      final result = await _authService.googleSignUp(
          idToken, account.displayName ?? '', account.email);
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        _showSuccessSnackbar(
          'Account Created',
          'Welcome, ${account.displayName ?? account.email}!',
        );
        Get.offAll(() => KanbanBoardScreen(
              username: account.displayName ?? account.email,
            ));
      } else {
        _showErrorSnackbar(
            'Signup failed (${result['statusCode']}). ${result['body']}');
      }
    } catch (e) {
      _showErrorSnackbar('Google sign-in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearRegisterFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
  }
}
