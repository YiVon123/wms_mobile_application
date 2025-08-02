import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    notifyListeners();
    final error = await _authService.signup(email, password, name, phone, address);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final error = await _authService.login(email, password);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    final error = await _authService.resetPassword(email);
    _isLoading = false;
    notifyListeners();
    return error;
  }
}
